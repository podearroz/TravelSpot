class Place {
  final String id;
  final String name;
  final String type;
  final String cuisine;
  final String description;
  final String? imageUrl;

  Place({
    required this.id,
    required this.name,
    required this.type,
    required this.cuisine,
    required this.description,
    this.imageUrl,
  });

  factory Place.fromMap(Map<String, dynamic> m) => Place(
        id: m['id']?.toString() ?? '',
        name: m['name'] ?? '',
        type: m['type'] ?? '',
        cuisine: m['cuisine'] ?? '',
        description: m['description'] ?? '',
        imageUrl: m['image_url'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': type,
        'cuisine': cuisine,
        'description': description,
        'image_url': imageUrl,
      };
}
