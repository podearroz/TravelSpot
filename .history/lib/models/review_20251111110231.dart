class Review {
  final String id;
  final String placeId;
  final String userId;
  final int rating; // 1-5
  final String comment;
  final String? imageUrl;

  Review({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.rating,
    required this.comment,
    this.imageUrl,
  });

  factory Review.fromMap(Map<String, dynamic> m) => Review(
        id: m['id']?.toString() ?? '',
        placeId: m['place_id'] ?? '',
        userId: m['user_id'] ?? '',
        rating: (m['rating'] is int)
            ? m['rating']
            : int.tryParse(m['rating']?.toString() ?? '0') ?? 0,
        comment: m['comment'] ?? '',
        imageUrl: m['image_url'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'place_id': placeId,
        'user_id': userId,
        'rating': rating,
        'comment': comment,
        'image_url': imageUrl,
      };
}
