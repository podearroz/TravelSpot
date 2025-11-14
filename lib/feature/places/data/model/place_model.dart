import 'package:json_annotation/json_annotation.dart';
import 'package:travelspot/feature/places/domain/entity/place.dart';

part 'place_model.g.dart';

@JsonSerializable()
class PlaceModel extends Place {
  const PlaceModel({
    required super.id,
    required super.name,
    required super.type,
    super.cuisine,
    super.description,
    super.imageUrl,
    super.rating,
    super.location,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);
}