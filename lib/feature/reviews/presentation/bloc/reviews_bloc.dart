import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_event.dart';
import 'package:travelspot/feature/reviews/domain/use_case/add_review_use_case.dart';
import 'package:travelspot/feature/reviews/domain/use_case/get_place_reviews_use_case.dart';
import 'package:travelspot/feature/reviews/presentation/bloc/reviews_event.dart';
import 'package:travelspot/feature/reviews/presentation/bloc/reviews_state.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_bloc.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final GetPlaceReviewsUseCase _getPlaceReviewsUseCase;
  final AddReviewUseCase _addReviewUseCase;
  final PlacesBloc _placesBloc;

  ReviewsBloc({
    required GetPlaceReviewsUseCase getPlaceReviewsUseCase,
    required AddReviewUseCase addReviewUseCase,
    required PlacesBloc placesBloc,
  })  : _getPlaceReviewsUseCase = getPlaceReviewsUseCase,
        _addReviewUseCase = addReviewUseCase,
        _placesBloc = placesBloc,
        super(ReviewsInitialState()) {
    on<LoadPlaceReviewsEvent>(_onLoadPlaceReviews);
    on<AddReviewEvent>(_onAddReview);
  }

  Future<void> _onLoadPlaceReviews(
    LoadPlaceReviewsEvent event,
    Emitter<ReviewsState> emit,
  ) async {
    emit(ReviewsLoadingState());

    final result = await _getPlaceReviewsUseCase(event.placeId);

    result.fold(
      (failure) => emit(ReviewsErrorState(failure.error)),
      (reviews) => emit(ReviewsLoadedState(reviews)),
    );
  }

  Future<void> _onAddReview(
    AddReviewEvent event,
    Emitter<ReviewsState> emit,
  ) async {
    final result = await _addReviewUseCase(
      event.placeId,
      event.authorId,
      event.rating,
      event.comment,
    );

    await result.fold(
      (failure) async => emit(ReviewsErrorState(failure.error)),
      (review) async {
        emit(ReviewAddedState(review));
        // Dispara o evento para recarregar a lista de lugares no PlacesBloc
        _placesBloc.add(LoadPlacesEvent());
        // Recarrega as reviews no ReviewsBloc
        add(LoadPlaceReviewsEvent(event.placeId));
      },
    );
  }
}
