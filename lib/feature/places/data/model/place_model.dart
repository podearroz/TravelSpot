import 'package:json_annotation/json_annotation.dart';
import 'package:travelspot/feature/places/domain/entity/place.dart';
import 'package:travelspot/feature/places/domain/entity/place_type.dart';
import 'package:travelspot/feature/places/domain/entity/cuisine.dart';
import 'package:travelspot/feature/places/domain/entity/place_photo.dart';

part 'place_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PlaceModel extends Place {
  const PlaceModel({
    required super.id,
    super.ownerId,
    required super.name,
    super.description,
    super.placeType,
    super.cuisines = const [],
    super.address,
    super.latitude,
    super.longitude,
    super.averageRating = 0.0,
    super.reviewCount = 0,
    super.isPublished = true,
    super.photos = const [],
    required super.createdAt,
    required super.updatedAt,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);

  factory PlaceModel.fromEntity(Place place) {
    return PlaceModel(
      id: place.id,
      ownerId: place.ownerId,
      name: place.name,
      description: place.description,
      placeType: place.placeType,
      cuisines: place.cuisines,
      address: place.address,
      latitude: place.latitude,
      longitude: place.longitude,
      averageRating: place.averageRating,
      reviewCount: place.reviewCount,
      isPublished: place.isPublished,
      photos: place.photos,
      createdAt: place.createdAt,
      updatedAt: place.updatedAt,
    );
  }
}
