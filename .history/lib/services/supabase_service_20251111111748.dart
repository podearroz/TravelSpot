import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/place.dart';
import '../models/review.dart';

class SupabaseService {
  static late final SupabaseClient _client;

  // Deve ser chamado após Supabase.initialize no main.dart
  static Future<void> initialize() async {
    _client = Supabase.instance.client;
  }

  // Autenticação (email/senha)
  static Future<bool> signInWithEmail(String email, String password) async {
    try {
      final res = await _client.auth
          .signInWithPassword(email: email, password: password);
      return res.user != null;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> registerWithEmail(String email, String password) async {
    try {
      final res = await _client.auth.signUp(email: email, password: password);
      return res.user != null || res.session != null;
    } catch (e) {
      return false;
    }
  }

  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (_) {}
  }

  // Busca lugares com filtros opcionais
  static Future<List<Place>> fetchPlaces(
      {String? type, String? cuisine}) async {
    try {
      var query = _client.from('places').select();
      if (type != null && type.isNotEmpty) query = query.eq('type', type);
      if (cuisine != null && cuisine.isNotEmpty)
        query = query.eq('cuisine', cuisine);
  // execute() is deprecated in newer versions of the Postgrest client;
  // keep using it for compatibility but silence the deprecation warning.
  // ignore: deprecated_member_use
  final res = await query.execute();
      final data = (res.data as List).cast<Map<String, dynamic>>();
      return data.map((m) => Place.fromMap(m)).toList();
    } catch (e) {
      // fallback mock
      return [
        Place(
            id: '1',
            name: 'Café Central',
            type: 'Café',
            cuisine: 'Cafeteria',
            description: 'Ótimo para um café e doce.',
            imageUrl: null),
        Place(
            id: '2',
            name: 'Restaurante do Porto',
            type: 'Restaurante',
            cuisine: 'Peixe',
            description: 'Frutos do mar frescos.',
            imageUrl: null),
      ];
    }
  }

  static Future<bool> addPlace(Place p) async {
    try {
  // ignore: deprecated_member_use
  await _client.from('places').insert(p.toMap()).execute();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> uploadImage(String fileName, Uint8List bytes) async {
    try {
      // usa bucket 'places'
      await _client.storage.from('places').uploadBinary(fileName, bytes);
      // getPublicUrl pode retornar String
      final publicUrl = _client.storage.from('places').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      return null;
    }
  }

  // Reviews CRUD
  static Future<List<Review>> fetchReviews(String placeId) async {
    try {
    // ignore: deprecated_member_use
    final res = await _client
      .from('reviews')
      .select()
      .eq('place_id', placeId)
      .execute();
      final data = (res.data as List).cast<Map<String, dynamic>>();
      return data.map((m) => Review.fromMap(m)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addReview(Review r) async {
    try {
  // ignore: deprecated_member_use
  await _client.from('reviews').insert(r.toMap()).execute();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> editReview(
      String id, Map<String, dynamic> changes) async {
    try {
  // ignore: deprecated_member_use
  await _client.from('reviews').update(changes).eq('id', id).execute();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteReview(String id) async {
    try {
  // ignore: deprecated_member_use
  await _client.from('reviews').delete().eq('id', id).execute();
      return true;
    } catch (e) {
      return false;
    }
  }
}
