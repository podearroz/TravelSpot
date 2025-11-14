import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:travelspot/feature/auth/data/model/auth_request_model.dart';
import 'package:travelspot/feature/auth/domain/entity/user.dart';
import 'package:travelspot/feature/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Try<User>> login(String email, String password) async {
    final request = LoginRequestModel(email: email, password: password);
    final result = await _remoteDataSource.login(request);
    
    return result.fold(
      (failure) => Rejection(failure),
      (response) => Success(response.user),
    );
  }

  @override
  Future<Try<User>> register(String email, String password, String name) async {
    final request = RegisterRequestModel(email: email, password: password, name: name);
    final result = await _remoteDataSource.register(request);
    
    return result.fold(
      (failure) => Rejection(failure),
      (response) => Success(response.user),
    );
  }

  @override
  Future<Try<void>> logout() async {
    return await _remoteDataSource.logout();
  }

  @override
  Future<Try<User?>> getCurrentUser() async {
    // Implementar busca do usuário atual (pode ser via token armazenado localmente)
    throw UnimplementedError();
  }
}