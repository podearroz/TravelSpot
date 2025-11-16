import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlacePhoto extends Equatable {
  final String id;
  final String placeId;
  final String uploaderId;
  final String storagePath;
  final DateTime createdAt;

  const PlacePhoto({
    required this.id,
    required this.placeId,
    required this.uploaderId,
    required this.storagePath,
    required this.createdAt,
  });

  /// Retorna a URL pública da imagem a partir do storage path
  String get url {
    // Se já é uma URL completa, retorna como está
    if (storagePath.startsWith('http://') || storagePath.startsWith('https://')) {
      return storagePath;
    }
    // Caso contrário, constrói a URL pública do Supabase
    return Supabase.instance.client.storage
        .from('place-photos')
        .getPublicUrl(storagePath);
  }

  @override
  List<Object> get props => [id, placeId, uploaderId, storagePath, createdAt];

  factory PlacePhoto.fromJson(Map<String, dynamic> json) {
    return PlacePhoto(
      id: json['id'] as String,
      placeId: json['place_id'] as String,
      uploaderId: json['uploader_id'] as String,
      storagePath: json['storage_path'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place_id': placeId,
      'uploader_id': uploaderId,
      'storage_path': storagePath,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
