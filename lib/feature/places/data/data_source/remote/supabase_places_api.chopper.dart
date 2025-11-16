// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_places_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SupabasePlacesApi extends SupabasePlacesApi {
  _$SupabasePlacesApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SupabasePlacesApi;

  @override
  Future<Response<dynamic>> getAllPlaces() {
    final Uri $url = Uri.parse('/places');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getPlaceById(String id) {
    final Uri $url = Uri.parse('/places/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> addPlace(Map<String, dynamic> place) {
    final Uri $url = Uri.parse('/places');
    final $body = place;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updatePlace(
    String id,
    Map<String, dynamic> updates,
  ) {
    final Uri $url = Uri.parse('/places/${id}');
    final $body = updates;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deletePlace(String id) {
    final Uri $url = Uri.parse('/places/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getPlaceTypes() {
    final Uri $url = Uri.parse('/place_types');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getCuisines() {
    final Uri $url = Uri.parse('/cuisines');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
