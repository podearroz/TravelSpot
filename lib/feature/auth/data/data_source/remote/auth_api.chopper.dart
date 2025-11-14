// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AuthApi extends AuthApi {
  _$AuthApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AuthApi;

  @override
  Future<Response<AuthResponseModel>> login(LoginRequestModel request) {
    final Uri $url = Uri.parse('/auth/login');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<AuthResponseModel, AuthResponseModel>($request);
  }

  @override
  Future<Response<AuthResponseModel>> register(RegisterRequestModel request) {
    final Uri $url = Uri.parse('/auth/register');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<AuthResponseModel, AuthResponseModel>($request);
  }

  @override
  Future<Response<void>> logout() {
    final Uri $url = Uri.parse('/auth/logout');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<void, void>($request);
  }
}
