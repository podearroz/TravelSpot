import 'package:travelspot/core/base/use_case.dart';
import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/auth/domain/entity/user.dart';
import 'package:travelspot/feature/auth/domain/repository/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

class LoginUseCase extends UseCase<User, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Try<User>> call(LoginParams params) async {
    return await _repository.login(params.email, params.password);
  }
}
