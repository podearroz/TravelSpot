import 'package:travelspot/core/errors/failure.dart';
import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/core/services/biometric_service.dart';
import 'package:travelspot/core/services/local_storage_service.dart';
import 'package:travelspot/feature/auth/domain/entity/user.dart';
import 'package:travelspot/feature/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

// If CacheFailure is not defined in failure.dart, define it below:
class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class CheckCachedUserUseCase {
  final AuthRepository _authRepository;
  final BiometricService _biometricService;
  final LocalStorageService _localStorageService;

  CheckCachedUserUseCase(
    this._authRepository,
    this._biometricService,
    this._localStorageService,
  );

  Future<Try<CachedUserInfo?>> call() async {
    try {
      // 1. Tenta recuperar a sessão do armazenamento local
      final sessionData = await _localStorageService.getSession();
      if (sessionData == null) {
        return Success(null); // Nenhum usuário em cache
      }

      // 2. Recupera o usuário da sessão
      final user = User.fromSupabase(sessionData.user);

      // 3. Verifica se a biometria está disponível
      final canUseBiometric = await _biometricService.canUseBiometricAuth();

      return Success(
        CachedUserInfo(user: user, canUseBiometric: canUseBiometric),
      );
    } catch (e) {
      return Rejection(
          CacheFailure('Failed to read cached user: ${e.toString()}'));
    }
  }
}

class CachedUserInfo {
  final User user;
  final bool canUseBiometric;

  CachedUserInfo({
    required this.user,
    required this.canUseBiometric,
  });
}
