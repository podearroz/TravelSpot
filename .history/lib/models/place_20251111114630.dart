class Place {
  final String id;
  final String? ownerId;
  final String name;
  final String? description;
  final int? placeTypeId;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double averageRating;
  final int reviewCount;
  final bool isPublished;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? photoUrls; // convenience field populated by frontend

  Place({
    required this.id,
    this.ownerId,
    required this.name,
    this.description,
    this.placeTypeId,
    this.address,
    this.latitude,
    this.longitude,
    this.averageRating = 0,
    this.reviewCount = 0,
    this.isPublished = true,
    this.createdAt,
    this.updatedAt,
    this.photoUrls,
  });

  factory Place.fromMap(Map<String, dynamic> m) => Place(
        id: m['id']?.toString() ?? '',
        ownerId: m['owner_id']?.toString(),
        name: m['name'] ?? '',
        description: m['description'],
        placeTypeId: m['place_type_id'] is int ? m['place_type_id'] : (m['place_type_id'] != null ? int.tryParse(m['place_type_id'].toString()) : null),
        address: m['address'],
        latitude: m['latitude'] is num ? (m['latitude'] as num).toDouble() : null,
        longitude: m['longitude'] is num ? (m['longitude'] as num).toDouble() : null,
        averageRating: m['average_rating'] is num ? (m['average_rating'] as num).toDouble() : 0,
        reviewCount: m['review_count'] is int ? m['review_count'] : (m['review_count'] != null ? int.tryParse(m['review_count'].toString()) ?? 0 : 0),
        isPublished: m['is_published'] ?? true,
        createdAt: m['created_at'] != null ? DateTime.tryParse(m['created_at'].toString()) : null,
        updatedAt: m['updated_at'] != null ? DateTime.tryParse(m['updated_at'].toString()) : null,
        photoUrls: m['photo_urls'] != null ? List<String>.from(m['photo_urls']) : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'owner_id': ownerId,
        'name': name,
        'description': description,
        'place_type_id': placeTypeId,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'average_rating': averageRating,
        'review_count': reviewCount,
        'is_published': isPublished,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
