import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/reviews/domain/entity/review.dart';
import 'package:travelspot/feature/reviews/domain/repository/review_repository.dart';

class GetPlaceReviewsUseCase {
  final ReviewRepository _repository;

  GetPlaceReviewsUseCase(this._repository);

  Future<Try<List<Review>>> call(String placeId) {
    return _repository.getPlaceReviews(placeId);
  }
}
