// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_favorites_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SupabaseFavoritesApi extends SupabaseFavoritesApi {
  _$SupabaseFavoritesApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SupabaseFavoritesApi;

  @override
  Future<Response<dynamic>> getUserFavorites(
    String userId,
    String select,
  ) {
    final Uri $url = Uri.parse('/favorites');
    final Map<String, dynamic> $params = <String, dynamic>{
      'user_id': userId,
      'select': select,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> addFavorite(Map<String, dynamic> favorite) {
    final Uri $url = Uri.parse('/favorites');
    final $body = favorite;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> removeFavorite(
    String userId,
    String placeId,
  ) {
    final Uri $url = Uri.parse('/favorites');
    final Map<String, dynamic> $params = <String, dynamic>{
      'user_id': userId,
      'place_id': placeId,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> checkIsFavorite(
    String userId,
    String placeId,
  ) {
    final Uri $url = Uri.parse('/favorites');
    final Map<String, dynamic> $params = <String, dynamic>{
      'user_id': userId,
      'place_id': placeId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
