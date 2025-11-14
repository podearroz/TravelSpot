import 'package:travelspot/core/errors/failure.dart';
import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/auth_api.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:travelspot/feature/auth/data/model/auth_request_model.dart';
import 'package:travelspot/feature/auth/data/model/auth_response_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApi _authApi;

  AuthRemoteDataSourceImpl(this._authApi);

  @override
  Future<Try<AuthResponseModel>> login(LoginRequestModel request) async {
    try {
      final response = await _authApi.login(request);
      
      if (response.isSuccessful && response.body != null) {
        return Success(response.body!);
      } else {
        return Rejection(AuthenticationFailure('Login failed'));
      }
    } catch (e) {
      return Rejection(ServerConnectionFailure(e));
    }
  }

  @override
  Future<Try<AuthResponseModel>> register(RegisterRequestModel request) async {
    try {
      final response = await _authApi.register(request);
      
      if (response.isSuccessful && response.body != null) {
        return Success(response.body!);
      } else {
        return Rejection(AuthenticationFailure('Registration failed'));
      }
    } catch (e) {
      return Rejection(ServerConnectionFailure(e));
    }
  }

  @override
  Future<Try<void>> logout() async {
    try {
      final response = await _authApi.logout();
      
      if (response.isSuccessful) {
        return Success(null);
      } else {
        return Rejection(AuthenticationFailure('Logout failed'));
      }
    } catch (e) {
      return Rejection(ServerConnectionFailure(e));
    }
  }
}