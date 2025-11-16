import 'package:equatable/equatable.dart';

class PlaceType extends Equatable {
  final int id;
  final String name;

  const PlaceType({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];

  factory PlaceType.fromJson(Map<String, dynamic> json) {
    return PlaceType(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
