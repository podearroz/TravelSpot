import 'package:chopper/chopper.dart';

part 'supabase_reviews_api.chopper.dart';

@ChopperApi()
abstract class SupabaseReviewsApi extends ChopperService {
  @GET(path: '/reviews')
  Future<Response<dynamic>> getPlaceReviews(
    @Query('place_id') String placeId,
    @Query('select') String select,
  );

  @POST(path: '/reviews')
  Future<Response<dynamic>> addReview(
    @Body() Map<String, dynamic> review,
  );

  @Patch(path: '/reviews')
  Future<Response<dynamic>> updateReview(
    @Query('id') String reviewId,
    @Body() Map<String, dynamic> updates,
  );

  @DELETE(path: '/reviews')
  Future<Response<dynamic>> deleteReview(
    @Query('id') String reviewId,
  );

  @GET(path: '/reviews')
  Future<Response<dynamic>> getUserReviewForPlace(
    @Query('place_id') String placeId,
    @Query('author_id') String authorId,
  );

  static SupabaseReviewsApi create(ChopperClient client) =>
      _$SupabaseReviewsApi(client);
}
