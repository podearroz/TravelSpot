import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String placeId;
  final String authorId;
  final int rating; // 1-5
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Review({
    required this.id,
    required this.placeId,
    required this.authorId,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        placeId,
        authorId,
        rating,
        comment,
        createdAt,
        updatedAt,
      ];

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      placeId: json['place_id'] as String,
      authorId: json['author_id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place_id': placeId,
      'author_id': authorId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
