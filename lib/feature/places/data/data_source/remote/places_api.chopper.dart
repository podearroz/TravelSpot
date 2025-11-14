// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PlacesApi extends PlacesApi {
  _$PlacesApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PlacesApi;

  @override
  Future<Response<List<PlaceModel>>> getPlaces() {
    final Uri $url = Uri.parse('/places');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<PlaceModel>, PlaceModel>($request);
  }

  @override
  Future<Response<PlaceModel>> getPlaceById(String id) {
    final Uri $url = Uri.parse('/places/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<PlaceModel, PlaceModel>($request);
  }

  @override
  Future<Response<PlaceModel>> createPlace(PlaceModel place) {
    final Uri $url = Uri.parse('/places');
    final $body = place;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<PlaceModel, PlaceModel>($request);
  }

  @override
  Future<Response<PlaceModel>> updatePlace(
    String id,
    PlaceModel place,
  ) {
    final Uri $url = Uri.parse('/places/${id}');
    final $body = place;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<PlaceModel, PlaceModel>($request);
  }

  @override
  Future<Response<void>> deletePlace(String id) {
    final Uri $url = Uri.parse('/places/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<void, void>($request);
  }
}
