import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelspot/core/services/biometric_service.dart';
import 'package:travelspot/feature/auth/domain/use_case/check_cached_user_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/login_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/register_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/logout_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/get_current_user_use_case.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_event.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_state.dart'
    as app_auth;

class AuthBloc extends Bloc<AuthEvent, app_auth.AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final CheckCachedUserUseCase _checkCachedUserUseCase;
  final BiometricService _biometricService;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required CheckCachedUserUseCase checkCachedUserUseCase,
    required BiometricService biometricService,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _checkCachedUserUseCase = checkCachedUserUseCase,
        _biometricService = biometricService,
        super(app_auth.AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<BiometricAuthRequested>(_onBiometricAuthRequested);
    on<AuthSyncRequested>(_onAuthSyncRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(app_auth.AuthLoading());

    // Garantir que qualquer sessão anterior seja limpa antes do login
    await _logoutUseCase();

    final params = LoginParams(email: event.email, password: event.password);
    final result = await _loginUseCase(params);

    result.fold(
      (failure) => emit(app_auth.AuthError(message: failure.toString())),
      (user) {
        print('✅ Usuário logado: ${user.email} (${user.id})');
        emit(app_auth.AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(app_auth.AuthLoading());

    // Garantir que qualquer sessão anterior seja limpa antes do registro
    await _logoutUseCase();

    final params = RegisterParams(
      email: event.email,
      password: event.password,
      name: event.name,
    );
    final result = await _registerUseCase(params);

    result.fold(
      (failure) => emit(app_auth.AuthError(message: failure.toString())),
      (user) {
        print('✅ Novo usuário registrado: ${user.email} (${user.id})');
        emit(app_auth.AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(app_auth.AuthLoading());
    print('🚪 Fazendo logout...');
    await _logoutUseCase();
    print('✅ Logout concluído, sessão limpa');
    emit(app_auth.AuthUnauthenticated(reason: 'User logged out'));
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(app_auth.AuthLoading());

    // Verificar se há sessão em cache
    final cachedUserResult = await _checkCachedUserUseCase();
    final cachedUserInfo = cachedUserResult.getOrElse(() => null);

    if (cachedUserInfo != null) {
      // Há usuário em cache - ir para tela de login para mostrar opção de biometria
      print(
          '✅ Sessão em cache encontrada, redirecionando para login com opção de biometria');
      emit(app_auth.AuthUnauthenticated(
          reason: 'Session cached, show biometric option'));
    } else {
      // Não há cache - ir para tela de login normal
      print('❌ Nenhuma sessão em cache, redirecionando para login');
      emit(app_auth.AuthUnauthenticated(reason: 'No cached session'));
    }
  }

  Future<void> _onBiometricAuthRequested(
    BiometricAuthRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    emit(app_auth.AuthLoading());

    // 1. Verificar se existe um usuário em cache
    final cachedUserResult = await _checkCachedUserUseCase();
    final cachedUserInfo = cachedUserResult.getOrElse(() => null);

    if (cachedUserInfo == null || !cachedUserInfo.canUseBiometric) {
      emit(app_auth.AuthError(
          message: 'Biometria não configurada ou nenhum usuário em cache.'));
      return;
    }

    // 2. Autenticar com biometria
    final isAuthenticated = await _biometricService.authenticateForLogin();
    if (!isAuthenticated) {
      emit(app_auth.AuthUnauthenticated(
          reason: 'Biometric authentication cancelled'));
      return;
    }

    // 3. Se a biometria for bem-sucedida, tentar obter o usuário atual
    // O use case cuidará de usar o refresh token se necessário
    final userResult = await _getCurrentUserUseCase();
    userResult.fold(
      (failure) => emit(app_auth.AuthError(
          message: 'Sessão expirada. Faça login novamente.')),
      (user) {
        if (user != null) {
          emit(app_auth.AuthAuthenticated(user: user));
        } else {
          emit(app_auth.AuthError(
              message:
                  'Não foi possível renovar a sessão. Faça login novamente.'));
        }
      },
    );
  }

  Future<void> _onAuthSyncRequested(
    AuthSyncRequested event,
    Emitter<app_auth.AuthState> emit,
  ) async {
    final result = await _getCurrentUserUseCase();
    result.fold(
      (failure) => emit(app_auth.AuthUnauthenticated(reason: 'Failed to sync')),
      (user) {
        if (user != null) {
          emit(app_auth.AuthAuthenticated(user: user));
        } else {
          emit(app_auth.AuthUnauthenticated(
              reason: 'No user found during sync'));
        }
      },
    );
  }
}
