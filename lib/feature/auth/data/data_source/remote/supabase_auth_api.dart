import 'package:chopper/chopper.dart';
import 'package:travelspot/feature/auth/data/model/supabase_auth_request_model.dart';

part 'supabase_auth_api.chopper.dart';

@ChopperApi()
abstract class SupabaseAuthApi extends ChopperService {
  @POST(path: "/auth/v1/signup")
  Future<Response<Map<String, dynamic>>> signUp(
    @Body() SupabaseSignUpRequestModel request,
  );

  @POST(path: "/auth/v1/token")
  Future<Response<Map<String, dynamic>>> signInWithPassword(
    @Query('grant_type') String grantType,
    @Field('email') String email,
    @Field('password') String password,
  );

  @POST(path: "/auth/v1/logout")
  Future<Response<void>> signOut(
    @Header('Authorization') String authToken,
  );

  @POST(path: "/auth/v1/recover")
  Future<Response<void>> resetPassword(
    @Body() SupabasePasswordResetRequestModel request,
  );

  @POST(path: "/auth/v1/token")
  Future<Response<Map<String, dynamic>>> refreshToken(
    @Query('grant_type') String grantType,
    @Field('refresh_token') String refreshToken,
  );

  @GET(path: "/auth/v1/user")
  Future<Response<Map<String, dynamic>>> getUser(
    @Header('Authorization') String authToken,
  );

  static SupabaseAuthApi create(ChopperClient client) {
    return _$SupabaseAuthApi(client);
  }
}
