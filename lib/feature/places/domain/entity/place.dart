import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String id;
  final String name;
  final String type;
  final String? cuisine;
  final String? description;
  final String? imageUrl;
  final double? rating;
  final String? location;

  const Place({
    required this.id,
    required this.name,
    required this.type,
    this.cuisine,
    this.description,
    this.imageUrl,
    this.rating,
    this.location,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        cuisine,
        description,
        imageUrl,
        rating,
        location,
      ];
}
