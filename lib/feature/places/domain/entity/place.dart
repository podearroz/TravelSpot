import 'package:equatable/equatable.dart';
import 'place_type.dart';
import 'cuisine.dart';
import 'place_photo.dart';

class Place extends Equatable {
  final String id;
  final String? ownerId;
  final String name;
  final String? description;
  final PlaceType? placeType;
  final List<Cuisine> cuisines;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double averageRating;
  final int reviewCount;
  final bool isPublished;
  final List<PlacePhoto> photos;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Place({
    required this.id,
    this.ownerId,
    required this.name,
    this.description,
    this.placeType,
    this.cuisines = const [],
    this.address,
    this.latitude,
    this.longitude,
    this.averageRating = 0.0,
    this.reviewCount = 0,
    this.isPublished = true,
    this.photos = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Retorna a URL da primeira foto ou null se não houver fotos
  String? get photoUrl => photos.isNotEmpty ? photos.first.url : null;

  @override
  List<Object?> get props => [
        id,
        ownerId,
        name,
        description,
        placeType,
        cuisines,
        address,
        latitude,
        longitude,
        averageRating,
        reviewCount,
        isPublished,
        photos,
        createdAt,
        updatedAt,
      ];

  factory Place.fromJson(Map<String, dynamic> json) {
    // Mapeia image_url para o array de photos se existir
    List<PlacePhoto> photosList = [];
    if (json['photos'] != null) {
      photosList = (json['photos'] as List)
          .map((photo) => PlacePhoto.fromJson(photo as Map<String, dynamic>))
          .toList();
    } else if (json['image_url'] != null && json['image_url'] != '') {
      // Se não tem array photos mas tem image_url, cria um PlacePhoto
      photosList = [
        PlacePhoto(
          id: '${json['id']}_photo',
          placeId: json['id'] as String,
          uploaderId: json['owner_id'] as String? ?? '',
          storagePath: json['image_url'] as String,
          createdAt: DateTime.parse(json['created_at'] as String),
        ),
      ];
    }

    return Place(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      placeType: json['place_type'] != null
          ? PlaceType.fromJson(json['place_type'] as Map<String, dynamic>)
          : null,
      cuisines: json['cuisines'] != null
          ? (json['cuisines'] as List)
              .map((cuisine) =>
                  Cuisine.fromJson(cuisine as Map<String, dynamic>))
              .toList()
          : [],
      address: json['address'] as String?,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      isPublished: json['is_published'] ?? true,
      photos: photosList,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'description': description,
      'place_type_id': placeType?.id,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'average_rating': averageRating,
      'review_count': reviewCount,
      'is_published': isPublished,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Place copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    PlaceType? placeType,
    List<Cuisine>? cuisines,
    String? address,
    double? latitude,
    double? longitude,
    double? averageRating,
    int? reviewCount,
    bool? isPublished,
    List<PlacePhoto>? photos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Place(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      placeType: placeType ?? this.placeType,
      cuisines: cuisines ?? this.cuisines,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      isPublished: isPublished ?? this.isPublished,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
