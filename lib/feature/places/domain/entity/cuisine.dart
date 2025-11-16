import 'package:equatable/equatable.dart';

class Cuisine extends Equatable {
  final int id;
  final String name;

  const Cuisine({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
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
