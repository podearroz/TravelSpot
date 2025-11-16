import 'package:equatable/equatable.dart';
import 'package:travelspot/feature/reviews/domain/entity/review.dart';

abstract class ReviewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReviewsInitialState extends ReviewsState {}

class ReviewsLoadingState extends ReviewsState {}

class ReviewsLoadedState extends ReviewsState {
  final List<Review> reviews;
  final double averageRating;
  final int totalReviews;

  ReviewsLoadedState(this.reviews)
      : averageRating = reviews.isEmpty
            ? 0.0
            : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                reviews.length,
        totalReviews = reviews.length;

  @override
  List<Object?> get props => [reviews, averageRating, totalReviews];
}

class ReviewAddedState extends ReviewsState {
  final Review review;

  ReviewAddedState(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewUpdatedState extends ReviewsState {
  final String reviewId;

  ReviewUpdatedState(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReviewDeletedState extends ReviewsState {
  final String reviewId;

  ReviewDeletedState(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReviewsErrorState extends ReviewsState {
  final String message;

  ReviewsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
