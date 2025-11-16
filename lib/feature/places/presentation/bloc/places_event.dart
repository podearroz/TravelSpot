import 'package:equatable/equatable.dart';
import 'package:travelspot/feature/places/domain/entity/place.dart';
import 'package:travelspot/feature/places/domain/entity/place_type.dart';
import 'package:travelspot/feature/places/domain/entity/cuisine.dart';

abstract class PlacesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPlacesEvent extends PlacesEvent {
  final int? limit;
  final int? offset;

  LoadPlacesEvent({this.limit, this.offset});

  @override
  List<Object?> get props => [limit, offset];
}

class LoadPlaceByIdEvent extends PlacesEvent {
  final String placeId;

  LoadPlaceByIdEvent(this.placeId);

  @override
  List<Object?> get props => [placeId];
}

class LoadPlaceTypesEvent extends PlacesEvent {}

class LoadCuisinesEvent extends PlacesEvent {}

class AddPlaceEvent extends PlacesEvent {
  final String name;
  final String? description;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int? placeTypeId;
  final List<int> cuisineIds;
  final String? ownerId;
  final String? imageUrl;

  AddPlaceEvent({
    required this.name,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.placeTypeId,
    this.cuisineIds = const [],
    this.ownerId,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        address,
        latitude,
        longitude,
        placeTypeId,
        cuisineIds,
        ownerId,
        imageUrl,
      ];
}

class UpdatePlaceEvent extends PlacesEvent {
  final String placeId;
  final Map<String, dynamic> updates;

  UpdatePlaceEvent(this.placeId, this.updates);

  @override
  List<Object?> get props => [placeId, updates];
}

class DeletePlaceEvent extends PlacesEvent {
  final String placeId;

  DeletePlaceEvent(this.placeId);

  @override
  List<Object?> get props => [placeId];
}
