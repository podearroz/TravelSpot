class Review {
  final String id;
  final String placeId;
  final String? authorId;
  final String? imageUrl;
  final int rating; // 1-5
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Review({
    required this.id,
    required this.placeId,
    String? authorIdParam,
    String? userIdParam,
    required this.rating,
    this.comment,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  }) : authorId = authorIdParam ?? userIdParam;

  factory Review.fromMap(Map<String, dynamic> m) {
    final ratingValue = m['rating'];
    final parsedRating = ratingValue is int
        ? ratingValue
        : int.tryParse(ratingValue?.toString() ?? '') ?? 0;

    DateTime? parseDate(Object? d) {
      if (d == null) return null;
      try {
        return DateTime.parse(d.toString());
      } catch (_) {
        return null;
      }
    }

    return Review(
      id: m['id']?.toString() ?? '',
      placeId: m['place_id']?.toString() ?? '',
      authorIdParam: m['author_id']?.toString(),
      userIdParam: m['user_id']?.toString(),
      imageUrl: m['image_url']?.toString(),
      rating: parsedRating,
      comment: m['comment']?.toString(),
      createdAt: parseDate(m['created_at']),
      updatedAt: parseDate(m['updated_at']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'place_id': placeId,
        'author_id': authorId,
        'user_id': authorId,
        'image_url': imageUrl,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

extension ReviewAliases on Review {
  String? get userId => authorId;
}
