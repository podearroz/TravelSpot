import 'package:travelspot/core/base/use_case.dart';
import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/auth/domain/repository/auth_repository.dart';

class LogoutUseCase extends UnitUseCase<void> {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Try<void>> call() async {
    return await _repository.logout();
  }
}
