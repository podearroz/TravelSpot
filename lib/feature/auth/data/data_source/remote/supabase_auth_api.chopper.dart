// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_auth_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SupabaseAuthApi extends SupabaseAuthApi {
  _$SupabaseAuthApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SupabaseAuthApi;

  @override
  Future<Response<Map<String, dynamic>>> signUp(
      SupabaseSignUpRequestModel request) {
    final Uri $url = Uri.parse('/auth/v1/signup');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> signInWithPassword(
    String grantType,
    String email,
    String password,
  ) {
    final Uri $url = Uri.parse('/auth/v1/token');
    final Map<String, dynamic> $params = <String, dynamic>{
      'grant_type': grantType
    };
    final $body = <String, dynamic>{
      'email': email,
      'password': password,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<void>> signOut(String authToken) {
    final Uri $url = Uri.parse('/auth/v1/logout');
    final Map<String, String> $headers = {
      'Authorization': authToken,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<void, void>($request);
  }

  @override
  Future<Response<void>> resetPassword(
      SupabasePasswordResetRequestModel request) {
    final Uri $url = Uri.parse('/auth/v1/recover');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<void, void>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> refreshToken(
    String grantType,
    String refreshToken,
  ) {
    final Uri $url = Uri.parse('/auth/v1/token');
    final Map<String, dynamic> $params = <String, dynamic>{
      'grant_type': grantType
    };
    final $body = <String, dynamic>{'refresh_token': refreshToken};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getUser(String authToken) {
    final Uri $url = Uri.parse('/auth/v1/user');
    final Map<String, String> $headers = {
      'Authorization': authToken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
