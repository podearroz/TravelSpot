class Review {
  final String id;
  final String placeId;
  final String? authorId;
  final int rating; // 1-5
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Review({
    required this.id,
    required this.placeId,
    this.authorId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory Review.fromMap(Map<String, dynamic> m) => Review(
        id: m['id']?.toString() ?? '',
        placeId: m['place_id']?.toString() ?? '',
        authorId: m['author_id']?.toString(),
        rating: (m['rating'] is int)
            ? m['rating']
            : int.tryParse(m['rating']?.toString() ?? '0') ?? 0,
        comment: m['comment'],
        createdAt: m['created_at'] != null
            ? DateTime.tryParse(m['created_at'].toString())
            : null,
        updatedAt: m['updated_at'] != null
            ? DateTime.tryParse(m['updated_at'].toString())
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'place_id': placeId,
        'author_id': authorId,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
class Review {
  final String id;
  final String placeId;
  final String userId;
  final String comment;
  final String? imageUrl;

  Review({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.comment,
    this.imageUrl,
  });

  factory Review.fromMap(Map<String, dynamic> m) => Review(
        id: m['id']?.toString() ?? '',
        placeId: m['place_id'] ?? '',
        userId: m['user_id'] ?? '',
            ? m['rating']
            : int.tryParse(m['rating']?.toString() ?? '0') ?? 0,
        comment: m['comment'] ?? '',
        imageUrl: m['image_url'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'rating': rating,
        'comment': comment,
        'image_url': imageUrl,
  final String? authorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Review({
    required this.id,
    required this.placeId,
    this.authorId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory Review.fromMap(Map<String, dynamic> m) => Review(
        id: m['id']?.toString() ?? '',
        placeId: m['place_id']?.toString() ?? '',
        authorId: m['author_id']?.toString(),
        rating: (m['rating'] is int) ? m['rating'] : int.tryParse(m['rating']?.toString() ?? '0') ?? 0,
        comment: m['comment'],
        createdAt: m['created_at'] != null ? DateTime.tryParse(m['created_at'].toString()) : null,
        updatedAt: m['updated_at'] != null ? DateTime.tryParse(m['updated_at'].toString()) : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'place_id': placeId,
        'author_id': authorId,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
      };
}
