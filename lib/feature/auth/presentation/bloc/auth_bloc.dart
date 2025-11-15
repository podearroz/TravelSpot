import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travelspot/core/services/biometric_service.dart';
import 'package:travelspot/feature/auth/domain/entity/user.dart' as app_user;
import 'package:travelspot/feature/auth/domain/use_case/login_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/register_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/logout_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/get_current_user_use_case.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_event.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_state.dart' as app_auth;

class AuthBloc extends Bloc<AuthEvent, app_auth.AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final BiometricService _biometricService;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required BiometricService biometricService,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _biometricService = biometricService,
        super(app_auth.AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<BiometricAuthRequested>(_onBiometricAuthRequested);
    on<BiometricAuthSkipped>(_onBiometricAuthSkipped);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(app_auth.AuthLoading());

    final params = LoginParams(email: event.email, password: event.password);
    final result = await _loginUseCase(params);

    result.fold(
      (failure) => emit(app_auth.AuthError(message: failure.toString())),
      (user) => emit(app_auth.AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(app_auth.AuthLoading());

    final params = RegisterParams(
      email: event.email,
      password: event.password,
      name: event.name,
    );
    final result = await _registerUseCase(params);

    result.fold(
      (failure) => emit(app_auth.AuthError(message: failure.toString())),
      (user) => emit(app_auth.AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(app_auth.AuthLoading());

    final result = await _logoutUseCase.call();

    result.fold(
      (failure) => emit(app_auth.AuthError(message: failure.toString())),
      (_) => emit(app_auth.AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(app_auth.AuthLoading());

    try {
      // Verificar apenas se há uma sessão ativa no Supabase
      // Não usar tokens salvos para autenticação automática
      final supabaseUser = Supabase.instance.client.auth.currentUser;
      
      if (supabaseUser != null) {
        print('Active Supabase session found: ${supabaseUser.email}');
        final user = app_user.User(id: supabaseUser.id, email: supabaseUser.email ?? '');
        emit(app_auth.AuthAuthenticated(user: user));
      } else {
        print('No active Supabase session, redirecting to login for biometric check');
        emit(app_auth.AuthUnauthenticated());
      }
    } catch (e) {
      print('Unexpected error during auth check: $e');
      emit(app_auth.AuthUnauthenticated());
    }
  }

  Future<void> _onBiometricAuthRequested(
    BiometricAuthRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(app_auth.AuthLoading());

    try {
      print('Starting biometric authentication...');
      
      final isAuthenticated = await _biometricService.authenticateForLogin();
      
      if (isAuthenticated) {
        print('Biometric authentication successful, getting user data...');
        
        // Buscar usuário (que incluirá verificação de cache e refresh token se necessário)
        final result = await _getCurrentUserUseCase();
        result.fold(
          (failure) {
            print('Failed to get user after biometric auth: ${failure.error}');
            emit(app_auth.AuthError(message: 'Falha ao obter dados do usuário: ${failure.error}'));
          },
          (user) {
            if (user != null) {
              print('User authenticated via biometric: ${user.email}');
              emit(app_auth.AuthAuthenticated(user: user));
            } else {
              print('No user found after biometric authentication');
              emit(app_auth.AuthError(message: 'Nenhum usuário encontrado. Faça login primeiro.'));
            }
          },
        );
      } else {
        print('Biometric authentication failed or cancelled by user');
        // Não mostrar erro se o usuário cancelou - apenas voltar ao estado anterior
        emit(app_auth.AuthUnauthenticated());
      }
    } catch (e) {
      print('Biometric authentication error: $e');
      emit(app_auth.AuthError(message: 'Erro na autenticação: $e'));
    }
  }

  Future<void> _onBiometricAuthSkipped(
    BiometricAuthSkipped event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    // Usuário optou por pular biometria, fazer logout e continuar na tela de login
    await _logoutUseCase.call();
    emit(app_auth.AuthUnauthenticated());
  }
}
