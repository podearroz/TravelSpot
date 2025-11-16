import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:travelspot/core/errors/failure.dart';
import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/core/services/local_storage_service.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/supabase_auth_api.dart';
import 'package:travelspot/feature/auth/domain/entity/user.dart';
import 'package:travelspot/feature/auth/domain/repository/auth_repository.dart';

class SupabaseAuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthApi _authApi;
  final LocalStorageService _localStorageService;
  final supabase.SupabaseClient _supabaseClient;

  SupabaseAuthRepositoryImpl(
    this._authApi,
    this._localStorageService,
    this._supabaseClient,
  );

  @override
  Future<Try<User>> login(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final session = response.session;
      final user = response.user;

      if (session != null && user != null) {
        await _localStorageService.saveSession(session);
        return Success(User.fromSupabase(user));
      } else {
        return Rejection(AuthenticationFailure('Invalid login response'));
      }
    } on supabase.AuthException catch (e) {
      return Rejection(AuthenticationFailure(e.message));
    } catch (e) {
      return Rejection(ServerConnectionFailure(e));
    }
  }

  @override
  Future<Try<User>> register(String email, String password, String name) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      final user = response.user;
      if (user != null) {
        // O Supabase pode ou não retornar uma sessão no registro.
        // Se retornar, salvamos.
        if (response.session != null) {
          await _localStorageService.saveSession(response.session!);
        }
        return Success(User.fromSupabase(user));
      } else {
        return Rejection(AuthenticationFailure('Registration failed: No user returned'));
      }
    } on supabase.AuthException catch (e) {
      return Rejection(AuthenticationFailure(e.message));
    } catch (e) {
      return Rejection(ServerConnectionFailure(e));
    }
  }

  @override
  Future<Try<void>> logout() async {
    try {
      await _supabaseClient.auth.signOut();
      await _localStorageService.clearSession();
      
      // Nota: Não chamamos SupabaseRestClient.reset() aqui para evitar
      // o erro "Cannot add new events after calling close" se houver
      // requisições em andamento. Os clientes serão recriados automaticamente
      // na próxima requisição com os novos headers (sem token).
      
      return Success(null);
    } on supabase.AuthException catch (e) {
      return Rejection(AuthenticationFailure('Logout failed: ${e.message}'));
    } catch (e) {
      return Rejection(ServerConnectionFailure(e));
    }
  }

  @override
  Future<Try<User?>> getCurrentUser() async {
    try {
      // 1. A fonte primária de verdade é o Supabase client.
      // Ele gerencia o estado da sessão, incluindo o refresh automático.
      final currentSession = _supabaseClient.auth.currentSession;
      final currentUser = _supabaseClient.auth.currentUser;

      if (currentSession != null && currentUser != null) {
        // Se há uma sessão ativa, o usuário está autenticado.
        // A sessão pode ter sido restaurada de um refresh token.
        // Salva a sessão mais recente para garantir consistência no próximo boot.
        await _localStorageService.saveSession(currentSession);
        return Success(User.fromSupabase(currentUser));
      }

      // 2. Se não há sessão ativa, o usuário está deslogado.
      // Limpar qualquer resquício de sessão local para evitar inconsistências.
      await _localStorageService.clearSession();
      return Success(null);
      
    } on supabase.AuthException catch (e) {
      // Se houver um erro de autenticação (ex: refresh token inválido),
      // o usuário deve ser deslogado.
      await logout();
      return Rejection(AuthenticationFailure('Session expired: ${e.message}'));
    } catch (e) {
      return Rejection(ServerConnectionFailure(e));
    }
  }
}
