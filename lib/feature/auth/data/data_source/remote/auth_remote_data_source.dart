import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/auth/data/model/auth_request_model.dart';
import 'package:travelspot/feature/auth/data/model/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<Try<AuthResponseModel>> login(LoginRequestModel request);
  Future<Try<AuthResponseModel>> register(RegisterRequestModel request);
  Future<Try<void>> logout();
}