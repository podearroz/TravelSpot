import 'package:travelspot/core/base/use_case.dart';
import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/auth/domain/entity/user.dart';
import 'package:travelspot/feature/auth/domain/repository/auth_repository.dart';

class RegisterParams {
  final String email;
  final String password;
  final String name;

  RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });
}

class RegisterUseCase extends UseCase<User, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Try<User>> call(RegisterParams params) async {
    return await _repository.register(params.email, params.password, params.name);
  }
}