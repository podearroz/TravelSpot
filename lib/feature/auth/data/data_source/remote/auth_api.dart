import 'package:chopper/chopper.dart';
import 'package:travelspot/feature/auth/data/model/auth_request_model.dart';
import 'package:travelspot/feature/auth/data/model/auth_response_model.dart';

part 'auth_api.chopper.dart';

@ChopperApi()
abstract class AuthApi extends ChopperService {
  @POST(path: "/auth/login")
  Future<Response<AuthResponseModel>> login(@Body() LoginRequestModel request);

  @POST(path: "/auth/register")
  Future<Response<AuthResponseModel>> register(
      @Body() RegisterRequestModel request);

  @POST(path: "/auth/logout")
  Future<Response<void>> logout();

  static AuthApi create(ChopperClient client) {
    return _$AuthApi(client);
  }
}
