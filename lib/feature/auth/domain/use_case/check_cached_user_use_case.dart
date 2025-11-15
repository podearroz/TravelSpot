import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/core/services/biometric_service.dart';
import 'package:travelspot/feature/auth/domain/entity/user.dart';
import 'package:travelspot/feature/auth/domain/repository/auth_repository.dart';

class CheckCachedUserUseCase {
  final AuthRepository _authRepository;
  final BiometricService _biometricService;

  CheckCachedUserUseCase(this._authRepository, this._biometricService);

  Future<Try<CachedUserInfo?>> call() async {
    final result = await _authRepository.getCurrentUser();
    
    return result.fold(
      (failure) => Rejection(failure),
      (user) async {
        if (user != null) {
          final canUseBiometric = await _biometricService.canUseBiometricAuth();
          return Success(CachedUserInfo(user: user, canUseBiometric: canUseBiometric));
        }
        return Success(null);
      },
    );
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