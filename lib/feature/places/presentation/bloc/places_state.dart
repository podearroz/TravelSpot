import 'package:equatable/equatable.dart';
import 'package:travelspot/feature/places/domain/entity/place.dart';
import 'package:travelspot/feature/places/domain/entity/place_type.dart';
import 'package:travelspot/feature/places/domain/entity/cuisine.dart';

abstract class PlacesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlacesInitialState extends PlacesState {}

class PlacesLoadingState extends PlacesState {}

class PlacesLoadedState extends PlacesState {
  final List<Place> places;
  final List<PlaceType> placeTypes;
  final List<Cuisine> cuisines;

  PlacesLoadedState({
    this.places = const [],
    this.placeTypes = const [],
    this.cuisines = const [],
  });

  @override
  List<Object?> get props => [places, placeTypes, cuisines];

  PlacesLoadedState copyWith({
    List<Place>? places,
    List<PlaceType>? placeTypes,
    List<Cuisine>? cuisines,
  }) {
    return PlacesLoadedState(
      places: places ?? this.places,
      placeTypes: placeTypes ?? this.placeTypes,
      cuisines: cuisines ?? this.cuisines,
    );
  }
}

class PlaceDetailLoadedState extends PlacesState {
  final Place place;

  PlaceDetailLoadedState(this.place);

  @override
  List<Object?> get props => [place];
}

class PlaceAddedState extends PlacesState {
  final Place place;

  PlaceAddedState(this.place);

  @override
  List<Object?> get props => [place];
}

class PlaceUpdatedState extends PlacesState {
  final Place place;

  PlaceUpdatedState(this.place);

  @override
  List<Object?> get props => [place];
}

class PlaceDeletedState extends PlacesState {
  final String placeId;

  PlaceDeletedState(this.placeId);

  @override
  List<Object?> get props => [placeId];
}

class PlacesErrorState extends PlacesState {
  final String message;

  PlacesErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
