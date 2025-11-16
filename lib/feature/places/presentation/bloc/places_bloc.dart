import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelspot/feature/places/domain/repository/places_repository.dart';
import 'package:travelspot/feature/places/domain/use_case/add_place_use_case.dart';
import 'package:travelspot/feature/places/domain/use_case/get_place_types_use_case.dart';
import 'package:travelspot/feature/places/domain/use_case/get_cuisines_use_case.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_event.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_state.dart';
import 'package:travelspot/core/functional/try.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final PlacesRepository _repository;
  final AddPlaceUseCase _addPlaceUseCase;
  final GetPlaceTypesUseCase _getPlaceTypesUseCase;
  final GetCuisinesUseCase _getCuisinesUseCase;

  PlacesBloc({
    required PlacesRepository repository,
    required AddPlaceUseCase addPlaceUseCase,
    required GetPlaceTypesUseCase getPlaceTypesUseCase,
    required GetCuisinesUseCase getCuisinesUseCase,
  })  : _repository = repository,
        _addPlaceUseCase = addPlaceUseCase,
        _getPlaceTypesUseCase = getPlaceTypesUseCase,
        _getCuisinesUseCase = getCuisinesUseCase,
        super(PlacesInitialState()) {
    on<LoadPlacesEvent>(_onLoadPlaces);
    on<LoadPlaceByIdEvent>(_onLoadPlaceById);
    on<LoadPlaceTypesEvent>(_onLoadPlaceTypes);
    on<LoadCuisinesEvent>(_onLoadCuisines);
    on<AddPlaceEvent>(_onAddPlace);
    on<UpdatePlaceEvent>(_onUpdatePlace);
    on<DeletePlaceEvent>(_onDeletePlace);
  }

  Future<void> _onLoadPlaces(
      LoadPlacesEvent event, Emitter<PlacesState> emit) async {
    emit(PlacesLoadingState());

    final result = await _repository.getPlaces(
      limit: event.limit,
      offset: event.offset,
    );

    result.fold(
      (failure) => emit(PlacesErrorState(failure.error)),
      (places) {
        if (state is PlacesLoadedState) {
          final currentState = state as PlacesLoadedState;
          emit(currentState.copyWith(places: places));
        } else {
          emit(PlacesLoadedState(places: places));
        }
      },
    );
  }

  Future<void> _onLoadPlaceById(
      LoadPlaceByIdEvent event, Emitter<PlacesState> emit) async {
    emit(PlacesLoadingState());

    final result = await _repository.getPlaceById(event.placeId);

    result.fold(
      (failure) => emit(PlacesErrorState(failure.error)),
      (place) => emit(PlaceDetailLoadedState(place)),
    );
  }

  Future<void> _onLoadPlaceTypes(
      LoadPlaceTypesEvent event, Emitter<PlacesState> emit) async {
    final result = await _getPlaceTypesUseCase();

    result.fold(
      (failure) => emit(PlacesErrorState(failure.error)),
      (placeTypes) {
        if (state is PlacesLoadedState) {
          final currentState = state as PlacesLoadedState;
          emit(currentState.copyWith(placeTypes: placeTypes));
        } else {
          emit(PlacesLoadedState(placeTypes: placeTypes));
        }
      },
    );
  }

  Future<void> _onLoadCuisines(
      LoadCuisinesEvent event, Emitter<PlacesState> emit) async {
    final result = await _getCuisinesUseCase();

    result.fold(
      (failure) => emit(PlacesErrorState(failure.error)),
      (cuisines) {
        if (state is PlacesLoadedState) {
          final currentState = state as PlacesLoadedState;
          emit(currentState.copyWith(cuisines: cuisines));
        } else {
          emit(PlacesLoadedState(cuisines: cuisines));
        }
      },
    );
  }

  Future<void> _onAddPlace(
      AddPlaceEvent event, Emitter<PlacesState> emit) async {
    emit(PlacesLoadingState());

    final params = AddPlaceParams(
      name: event.name,
      description: event.description,
      address: event.address,
      latitude: event.latitude,
      longitude: event.longitude,
      placeTypeId: event.placeTypeId,
      cuisineIds: event.cuisineIds,
      ownerId: event.ownerId,
      imageUrl: event.imageUrl,
    );

    final result = await _addPlaceUseCase(params);

    result.fold(
      (failure) => emit(PlacesErrorState(failure.error)),
      (place) => emit(PlaceAddedState(place)),
    );
  }

  Future<void> _onUpdatePlace(
      UpdatePlaceEvent event, Emitter<PlacesState> emit) async {
    emit(PlacesLoadingState());

    final result = await _repository.updatePlace(event.placeId, event.updates);

    result.fold(
      (failure) => emit(PlacesErrorState(failure.error)),
      (place) => emit(PlaceUpdatedState(place)),
    );
  }

  Future<void> _onDeletePlace(
      DeletePlaceEvent event, Emitter<PlacesState> emit) async {
    emit(PlacesLoadingState());

    final result = await _repository.deletePlace(event.placeId);

    result.fold(
      (failure) => emit(PlacesErrorState(failure.error)),
      (_) => emit(PlaceDeletedState(event.placeId)),
    );
  }
}
