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
      authorId: m['author_id']?.toString(),
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
        'rating': rating,
        'comment': comment,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
