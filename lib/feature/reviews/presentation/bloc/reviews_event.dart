import 'package:equatable/equatable.dart';

abstract class ReviewsEvent extends Equatable {
  const ReviewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPlaceReviewsEvent extends ReviewsEvent {
  final String placeId;

  const LoadPlaceReviewsEvent(this.placeId);

  @override
  List<Object?> get props => [placeId];
}

class AddReviewEvent extends ReviewsEvent {
  final String placeId;
  final String authorId;
  final int rating;
  final String? comment;

  const AddReviewEvent({
    required this.placeId,
    required this.authorId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [placeId, authorId, rating, comment];
}

class UpdateReviewEvent extends ReviewsEvent {
  final String reviewId;
  final int rating;
  final String? comment;

  const UpdateReviewEvent({
    required this.reviewId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [reviewId, rating, comment];
}

class DeleteReviewEvent extends ReviewsEvent {
  final String reviewId;

  const DeleteReviewEvent(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}
