// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceModel _$PlaceModelFromJson(Map<String, dynamic> json) => PlaceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      cuisine: json['cuisine'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      location: json['location'] as String?,
    );

Map<String, dynamic> _$PlaceModelToJson(PlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'cuisine': instance.cuisine,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'rating': instance.rating,
      'location': instance.location,
    };
