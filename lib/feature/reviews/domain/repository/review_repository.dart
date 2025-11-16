import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/reviews/domain/entity/review.dart';

abstract class ReviewRepository {
  Future<Try<List<Review>>> getPlaceReviews(String placeId);
  Future<Try<Review>> addReview(
      String placeId, String authorId, int rating, String? comment);
  Future<Try<void>> updateReview(String reviewId, int rating, String? comment);
  Future<Try<void>> deleteReview(String reviewId);
  Future<Try<Review?>> getUserReviewForPlace(String placeId, String userId);
}
