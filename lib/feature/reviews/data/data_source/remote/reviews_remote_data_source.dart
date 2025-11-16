import 'package:travelspot/feature/reviews/domain/entity/review.dart';

abstract class ReviewsRemoteDataSource {
  Future<List<Review>> getPlaceReviews(String placeId);
  Future<Review> addReview(
      String placeId, String authorId, int rating, String? comment);
  Future<void> updateReview(String reviewId, int rating, String? comment);
  Future<void> deleteReview(String reviewId);
  Future<Review?> getUserReviewForPlace(String placeId, String userId);
}
