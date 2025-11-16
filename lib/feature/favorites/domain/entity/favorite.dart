import 'package:equatable/equatable.dart';
import '../../../places/domain/entity/place.dart';

class Favorite extends Equatable {
  final String userId;
  final String placeId;
  final DateTime createdAt;
  final Place? place; // Para quando buscar favoritos com dados do place

  const Favorite({
    required this.userId,
    required this.placeId,
    required this.createdAt,
    this.place,
  });

  @override
  List<Object?> get props => [userId, placeId, createdAt, place];

  factory Favorite.fromJson(Map<String, dynamic> json) {
    try {
      Place? place;

      // Tentar fazer parse do place se existir
      if (json['places'] != null) {
        try {
          place = Place.fromJson(json['places'] as Map<String, dynamic>);
        } catch (e) {
          print('⚠️ Error parsing place from favorites: $e');
          place = null;
        }
      } else if (json['place'] != null) {
        try {
          place = Place.fromJson(json['place'] as Map<String, dynamic>);
        } catch (e) {
          print('⚠️ Error parsing place from favorites: $e');
          place = null;
        }
      }

      return Favorite(
        userId: json['user_id'] as String,
        placeId: json['place_id'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        place: place,
      );
    } catch (e, stackTrace) {
      print('❌ Error parsing Favorite from JSON: $e');
      print('JSON: $json');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'place_id': placeId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
