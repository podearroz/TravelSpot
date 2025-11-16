import 'package:travelspot/core/errors/failure.dart';
import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/reviews/domain/entity/review.dart';
import 'package:travelspot/feature/reviews/domain/repository/review_repository.dart';

class AddReviewUseCase {
  final ReviewRepository _repository;

  AddReviewUseCase(this._repository);

  Future<Try<Review>> call(
      String placeId, String authorId, int rating, String? comment) {
    if (rating < 1 || rating > 5) {
      return Future.value(
        Rejection(
            KnownFailure('INVALID_RATING', 'Rating deve estar entre 1 e 5')),
      );
    }

    return _repository.addReview(placeId, authorId, rating, comment);
  }
}
