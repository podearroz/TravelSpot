// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_reviews_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SupabaseReviewsApi extends SupabaseReviewsApi {
  _$SupabaseReviewsApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SupabaseReviewsApi;

  @override
  Future<Response<dynamic>> getPlaceReviews(
    String placeId,
    String select,
  ) {
    final Uri $url = Uri.parse('/reviews');
    final Map<String, dynamic> $params = <String, dynamic>{
      'place_id': placeId,
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
  Future<Response<dynamic>> addReview(Map<String, dynamic> review) {
    final Uri $url = Uri.parse('/reviews');
    final $body = review;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateReview(
    String reviewId,
    Map<String, dynamic> updates,
  ) {
    final Uri $url = Uri.parse('/reviews');
    final Map<String, dynamic> $params = <String, dynamic>{'id': reviewId};
    final $body = updates;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteReview(String reviewId) {
    final Uri $url = Uri.parse('/reviews');
    final Map<String, dynamic> $params = <String, dynamic>{'id': reviewId};
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getUserReviewForPlace(
    String placeId,
    String authorId,
  ) {
    final Uri $url = Uri.parse('/reviews');
    final Map<String, dynamic> $params = <String, dynamic>{
      'place_id': placeId,
      'author_id': authorId,
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
