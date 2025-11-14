import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelspot/feature/auth/domain/use_case/login_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/register_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/logout_use_case.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_event.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final params = LoginParams(email: event.email, password: event.password);
    final result = await _loginUseCase(params);

    result.fold(
      (failure) => emit(AuthError(message: failure.toString())),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final params = RegisterParams(
      email: event.email,
      password: event.password,
      name: event.name,
    );
    final result = await _registerUseCase(params);

    result.fold(
      (failure) => emit(AuthError(message: failure.toString())),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _logoutUseCase.call();

    result.fold(
      (failure) => emit(AuthError(message: failure.toString())),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Implementar verificação de autenticação
    emit(AuthUnauthenticated());
  }
}
