import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelspot/core/errors/failure.dart';
import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/supabase_auth_api.dart';
import 'package:travelspot/feature/auth/data/model/supabase_auth_request_model.dart';
import 'package:travelspot/feature/auth/domain/entity/user.dart';
import 'package:travelspot/feature/auth/domain/repository/auth_repository.dart';

class SupabaseAuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthApi _authApi;
  
  // Chaves para armazenamento local
  static const String _accessTokenKey = 'supabase_access_token';
  static const String _refreshTokenKey = 'supabase_refresh_token';
  static const String _userIdKey = 'supabase_user_id';
  static const String _userEmailKey = 'supabase_user_email';
  static const String _expiresAtKey = 'supabase_expires_at';
  static const String _lastRefreshKey = 'supabase_last_refresh';
  
  // Margem de segurança para renovação de token (5 minutos antes de expirar)
  static const int _refreshMarginSeconds = 300;
  
  // Cache do usuário atual
  User? _cachedUser;

  SupabaseAuthRepositoryImpl(this._authApi);

  @override
  Future<Try<User>> login(String email, String password) async {
    try {
      final response = await _authApi.signInWithPassword(
        'password', // grant_type como query parameter
        email,      // email como field
        password,   // password como field
      );

      if (response.isSuccessful && response.body != null) {
        final data = response.body!;
        
        // Verificar se temos dados de autenticação
        final accessToken = data['access_token'] as String?;
        final refreshToken = data['refresh_token'] as String?;
        final expiresAt = data['expires_at'] as int?;
        final userData = data['user'] as Map<String, dynamic>?;
        
        if (accessToken != null && userData != null) {
          // Salvar dados da sessão (incluindo cache)
          await _saveAuthData(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: expiresAt,
            user: userData,
          );
          
          // Retornar usuário do cache (garantindo consistência)
          return Success(_cachedUser!);
        } else {
          return Rejection(AuthenticationFailure('Invalid login response'));
        }
      } else {
        final errorMessage = _extractErrorMessage(response.body);
        return Rejection(AuthenticationFailure('Login failed: $errorMessage'));
      }
    } catch (e) {
      return Rejection(ServerConnectionFailure(e));
    }
  }

  @override
  Future<Try<User>> register(String email, String password, String name) async {
    try {
      final request = SupabaseSignUpRequestModel(
        email: email,
        password: password,
        data: {'name': name}, // Incluir nome nos metadados
      );

      final response = await _authApi.signUp(request);

      if (response.isSuccessful && response.body != null) {
        final data = response.body!;
        
        // O Supabase pode retornar dados diferentes para signup
        final accessToken = data['access_token'] as String?;
        final refreshToken = data['refresh_token'] as String?;
        final expiresAt = data['expires_at'] as int?;
        final userData = data['user'] as Map<String, dynamic>?;
        final session = data['session'] as Map<String, dynamic>?;
        
        // Se temos uma sessão, extrair dados dela
        String? finalAccessToken = accessToken;
        String? finalRefreshToken = refreshToken;
        int? finalExpiresAt = expiresAt;
        Map<String, dynamic>? finalUser = userData;
        
        if (session != null) {
          finalAccessToken = finalAccessToken ?? session['access_token'] as String?;
          finalRefreshToken = finalRefreshToken ?? session['refresh_token'] as String?;
          finalExpiresAt = finalExpiresAt ?? session['expires_at'] as int?;
          finalUser = finalUser ?? session['user'] as Map<String, dynamic>?;
        }
        
        if (finalUser != null) {
          // Salvar dados da sessão se temos token (incluindo cache)
          if (finalAccessToken != null) {
            await _saveAuthData(
              accessToken: finalAccessToken,
              refreshToken: finalRefreshToken,
              expiresAt: finalExpiresAt,
              user: finalUser,
            );
            
            // Retornar usuário do cache (garantindo consistência)
            return Success(_cachedUser!);
          } else {
            // Se não temos token, criar usuário temporário sem cache
            final user = User(
              id: finalUser['id'] as String,
              email: finalUser['email'] as String,
            );
            return Success(user);
          }
        } else {
          return Rejection(AuthenticationFailure('Registration failed: Invalid response'));
        }
      } else {
        final errorMessage = _extractErrorMessage(response.body);
        return Rejection(AuthenticationFailure('Registration failed: $errorMessage'));
      }
    } catch (e) {
      return Rejection(ServerConnectionFailure(e));
    }
  }

  @override
  Future<Try<void>> logout() async {
    try {
      // Tentar fazer logout no servidor se tivermos um token
      final accessToken = await _getStoredAccessToken();
      
      if (accessToken != null) {
        try {
          await _authApi.signOut('Bearer $accessToken');
        } catch (e) {
          // Ignorar erros de logout no servidor, mas continuar limpando dados locais
          print('Warning: Server logout failed: $e');
        }
      }
      
      // Sempre limpar dados locais e cache
      await _clearAuthData();
      
      return Success(null);
    } catch (e) {
      return Rejection(AuthenticationFailure('Logout failed: ${e.toString()}'));
    }
  }

  @override
  Future<Try<User?>> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_userIdKey);
      final email = prefs.getString(_userEmailKey);
      final accessToken = prefs.getString(_accessTokenKey);
      final refreshToken = prefs.getString(_refreshTokenKey);
      final expiresAt = prefs.getInt(_expiresAtKey);
      
      // Se não temos dados básicos, retornar null
      if (userId == null || email == null || accessToken == null) {
        return Success(null);
      }
      
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      
      // Verificar se o token precisa ser renovado
      if (expiresAt != null && refreshToken != null) {
        // Se o token expira em menos de 5 minutos, tentar renovar
        if (now >= (expiresAt - _refreshMarginSeconds)) {
          final refreshResult = await _refreshAccessToken(refreshToken);
          
          // Verificar se o refresh falhou
          final refreshFailed = refreshResult.fold(
            (failure) {
              // Falha na renovação, limpar dados e fazer logout
              print('Failed to refresh token: ${failure.error}, clearing auth data');
              return true;
            },
            (_) {
              // Token renovado com sucesso, continuar
              print('Token refreshed successfully');
              return false;
            },
          );
          
          if (refreshFailed) {
            await _clearAuthData();
            _cachedUser = null;
            return Success(null);
          }
        } else if (now >= expiresAt) {
          // Token expirado sem possibilidade de renovação
          print('Token expired, clearing auth data');
          await _clearAuthData();
          _cachedUser = null;
          return Success(null);
        }
      }
      
      // Criar e cachear usuário
      final user = User(
        id: userId,
        email: email,
      );
      
      _cachedUser = user;
      return Success(user);
      
    } catch (e) {
      return Rejection(AuthenticationFailure('Failed to get current user: ${e.toString()}'));
    }
  }

  // Métodos auxiliares para persistência de dados
  
  Future<void> _saveAuthData({
    required String accessToken,
    String? refreshToken,
    int? expiresAt,
    Map<String, dynamic>? user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setInt(_lastRefreshKey, DateTime.now().millisecondsSinceEpoch ~/ 1000);
    
    if (refreshToken != null) {
      await prefs.setString(_refreshTokenKey, refreshToken);
    }
    
    if (expiresAt != null) {
      await prefs.setInt(_expiresAtKey, expiresAt);
    }
    
    if (user != null) {
      final userId = user['id'] as String?;
      final email = user['email'] as String?;
      
      if (userId != null) {
        await prefs.setString(_userIdKey, userId);
        
        // Atualizar cache do usuário
        if (email != null) {
          _cachedUser = User(id: userId, email: email);
        }
      }
      
      if (email != null) {
        await prefs.setString(_userEmailKey, email);
      }
    }
  }
  
  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    
    await Future.wait([
      prefs.remove(_accessTokenKey),
      prefs.remove(_refreshTokenKey),
      prefs.remove(_userIdKey),
      prefs.remove(_userEmailKey),
      prefs.remove(_expiresAtKey),
      prefs.remove(_lastRefreshKey),
    ]);
    
    // Limpar cache
    _cachedUser = null;
  }
  
  Future<String?> _getStoredAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }
  
  Future<Try<void>> _refreshAccessToken(String refreshToken) async {
    try {
      final response = await _authApi.refreshToken(
        'refresh_token',  // grant_type
        refreshToken,     // refresh_token
      );
      
      if (response.isSuccessful && response.body != null) {
        final data = response.body!;
        
        final accessToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;
        final expiresAt = data['expires_at'] as int?;
        final userData = data['user'] as Map<String, dynamic>?;
        
        if (accessToken != null) {
          await _saveAuthData(
            accessToken: accessToken,
            refreshToken: newRefreshToken ?? refreshToken, // usar o novo ou manter o antigo
            expiresAt: expiresAt,
            user: userData,
          );
          
          return Success(null);
        } else {
          return Rejection(AuthenticationFailure('Invalid refresh response'));
        }
      } else {
        final errorMessage = _extractErrorMessage(response.body);
        return Rejection(AuthenticationFailure('Token refresh failed: $errorMessage'));
      }
    } catch (e) {
      return Rejection(ServerConnectionFailure(e));
    }
  }
  

  
  String _extractErrorMessage(Map<String, dynamic>? errorBody) {
    if (errorBody == null) return 'Unknown error';
    
    // Tentar extrair mensagem de erro do Supabase
    final message = errorBody['message'] as String? ?? 
                   errorBody['error_description'] as String? ??
                   errorBody['error'] as String? ??
                   'Unknown error';
    
    return message;
  }
}
