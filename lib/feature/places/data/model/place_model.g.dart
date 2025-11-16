// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceModel _$PlaceModelFromJson(Map<String, dynamic> json) => PlaceModel(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      placeType: json['placeType'] == null
          ? null
          : PlaceType.fromJson(json['placeType'] as Map<String, dynamic>),
      cuisines: (json['cuisines'] as List<dynamic>?)
              ?.map((e) => Cuisine.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      isPublished: json['isPublished'] as bool? ?? true,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => PlacePhoto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PlaceModelToJson(PlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'placeType': instance.placeType?.toJson(),
      'cuisines': instance.cuisines.map((e) => e.toJson()).toList(),
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'averageRating': instance.averageRating,
      'reviewCount': instance.reviewCount,
      'isPublished': instance.isPublished,
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
