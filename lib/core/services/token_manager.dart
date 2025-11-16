import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelspot/feature/auth/data/repository/supabase_auth_repository_impl.dart';

/// Serviço responsável pelo gerenciamento seguro de tokens JWT
/// Integra com o sistema de autenticação existente
class TokenManager {
  static TokenManager? _instance;
  static TokenManager get instance => _instance ??= TokenManager._();

  TokenManager._();

  // Chaves para armazenamento - usando as mesmas do SupabaseAuthRepositoryImpl
  static const String _accessTokenKey = 'supabase_access_token';
  static const String _expiresAtKey = 'supabase_expires_at';

  // Cache em memória para melhor performance
  String? _cachedToken;
  int? _cachedExpiresAt;

  /// Obtém o token de acesso atual
  /// Verifica cache em memória primeiro, depois SharedPreferences
  Future<String?> getAccessToken() async {
    // Se temos cache válido, usar
    if (_cachedToken != null && _isTokenValid()) {
      return _cachedToken;
    }

    // Buscar do armazenamento persistente
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_accessTokenKey);
    _cachedExpiresAt = prefs.getInt(_expiresAtKey);

    // Verificar se token ainda é válido
    if (_cachedToken != null && _isTokenValid()) {
      return _cachedToken;
    }

    // Token expirado ou inexistente
    _clearCache();
    return null;
  }

  /// Salva o token de acesso
  /// Usado pelo sistema de autenticação quando há login/refresh
  Future<void> setAccessToken(String? token, {int? expiresAt}) async {
    _cachedToken = token;
    _cachedExpiresAt = expiresAt;

    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString(_accessTokenKey, token);
      if (expiresAt != null) {
        await prefs.setInt(_expiresAtKey, expiresAt);
      }
    } else {
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_expiresAtKey);
    }
  }

  /// Remove o token (logout)
  Future<void> clearToken() async {
    _clearCache();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_accessTokenKey),
      prefs.remove(_expiresAtKey),
    ]);
  }

  /// Verifica se o token atual é válido (não expirado)
  bool _isTokenValid() {
    if (_cachedExpiresAt == null)
      return true; // Se não tem expiração, assumir válido

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    const marginSeconds = 300; // 5 minutos de margem

    return _cachedExpiresAt! > (now + marginSeconds);
  }

  /// Limpa o cache em memória
  void _clearCache() {
    _cachedToken = null;
    _cachedExpiresAt = null;
  }

  /// Verifica se há um usuário autenticado (tem token válido)
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null;
  }
}
