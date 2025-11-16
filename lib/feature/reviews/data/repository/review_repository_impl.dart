import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/core/errors/failure.dart';
import 'package:travelspot/feature/reviews/data/data_source/remote/reviews_remote_data_source.dart';
import 'package:travelspot/feature/reviews/domain/entity/review.dart';
import 'package:travelspot/feature/reviews/domain/repository/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewsRemoteDataSource _remoteDataSource;

  ReviewRepositoryImpl(this._remoteDataSource);

  @override
  Future<Try<List<Review>>> getPlaceReviews(String placeId) async {
    try {
      final reviews = await _remoteDataSource.getPlaceReviews(placeId);
      return Success(reviews);
    } catch (e) {
      return Rejection(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Try<Review>> addReview(
      String placeId, String authorId, int rating, String? comment) async {
    try {
      final review =
          await _remoteDataSource.addReview(placeId, authorId, rating, comment);
      return Success(review);
    } catch (e) {
      return Rejection(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Try<void>> updateReview(
      String reviewId, int rating, String? comment) async {
    try {
      await _remoteDataSource.updateReview(reviewId, rating, comment);
      return Success(null);
    } catch (e) {
      return Rejection(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Try<void>> deleteReview(String reviewId) async {
    try {
      await _remoteDataSource.deleteReview(reviewId);
      return Success(null);
    } catch (e) {
      return Rejection(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Try<Review?>> getUserReviewForPlace(
      String placeId, String userId) async {
    try {
      final review =
          await _remoteDataSource.getUserReviewForPlace(placeId, userId);
      return Success(review);
    } catch (e) {
      return Rejection(UnknownFailure(e.toString()));
    }
  }
}
