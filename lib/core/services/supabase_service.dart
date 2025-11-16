// Temporariamente ignoramos o uso de membros depreciados do cliente Supabase
// porque a API tem variações entre versões; planeje migrar para a API
// mais nova do Supabase/Postgrest quando consolidarmos a versão.
// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../errors/exceptions.dart';

class SupabaseService {
  static late final SupabaseClient _client;

  // Deve ser chamado após Supabase.initialize no main.dart
  static Future<void> initialize() async {
    _client = Supabase.instance.client;
  }

  SupabaseClient get client => _client;

  // Autenticação (email/senha)
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      final res = await _client.auth
          .signInWithPassword(email: email, password: password);
      return res.user != null;
    } catch (e) {
      throw TravelSpotAuthException(
        'Erro ao fazer login: ${e.toString()}',
      );
    }
  }

  Future<bool> registerWithEmail(String email, String password) async {
    try {
      final res = await _client.auth.signUp(email: email, password: password);
      return res.user != null || res.session != null;
    } catch (e) {
      throw TravelSpotAuthException(
        'Erro ao registrar: ${e.toString()}',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw TravelSpotAuthException(
        'Erro ao fazer logout: ${e.toString()}',
      );
    }
  }

  String? getCurrentUserId() {
    return _client.auth.currentUser?.id;
  }

  bool get isLoggedIn => _client.auth.currentUser != null;

  // Busca lugares com filtros opcionais
  Future<List<Map<String, dynamic>>> fetchPlaces(
      {String? type, String? cuisine}) async {
    try {
      var query = _client.from('places').select();
      if (type != null && type.isNotEmpty) query = query.eq('type', type);
      if (cuisine != null && cuisine.isNotEmpty) {
        query = query.eq('cuisine', cuisine);
      }

      final data = await query;
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      throw ServerException(
        'Erro ao buscar lugares: ${e.toString()}',
      );
    }
  }

  // Adiciona um novo lugar
  Future<Map<String, dynamic>> addPlace({
    required String name,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? type,
    String? cuisine,
    String? imageUrl, // Novo campo para a URL da imagem
  }) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) {
        throw TravelSpotAuthException('Usuário não autenticado');
      }

      final data = await _client
          .from('places')
          .insert({
            'owner_id': userId,
            'name': name,
            'description': description,
            'address': address,
            'latitude': latitude,
            'longitude': longitude,
            'type': type,
            'cuisine': cuisine,
            'image_url': imageUrl, // Adicionado ao insert
          })
          .select()
          .single();

      return Map<String, dynamic>.from(data);
    } catch (e) {
      throw ServerException(
        'Erro ao adicionar lugar: ${e.toString()}',
      );
    }
  }

  // Busca avaliações de um lugar
  Future<List<Map<String, dynamic>>> fetchReviews(String placeId) async {
    try {
      final data = await _client
          .from('reviews')
          .select()
          .eq('place_id', placeId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      throw ServerException(
        'Erro ao buscar avaliações: ${e.toString()}',
      );
    }
  }

  // Adiciona uma nova avaliação
  Future<Map<String, dynamic>> addReview({
    required String placeId,
    required int rating,
    String? comment,
    String? imageUrl,
  }) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) {
        throw TravelSpotAuthException('Usuário não autenticado');
      }

      final data = await _client
          .from('reviews')
          .insert({
            'place_id': placeId,
            'author_id': userId,
            'rating': rating,
            'comment': comment,
            'image_url': imageUrl,
          })
          .select()
          .single();

      return Map<String, dynamic>.from(data);
    } catch (e) {
      throw ServerException(
        'Erro ao adicionar avaliação: ${e.toString()}',
      );
    }
  }

  // Upload de imagem para um lugar
  Future<String> uploadPlaceImage(Uint8List imageBytes, String fileName) async {
    try {
      final path = 'public/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      await _client.storage.from('place-photos').uploadBinary(
            path,
            imageBytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      return _client.storage.from('place-photos').getPublicUrl(path);
    } catch (e) {
      throw ServerException(
        'Erro ao fazer upload da imagem: ${e.toString()}',
      );
    }
  }
}
