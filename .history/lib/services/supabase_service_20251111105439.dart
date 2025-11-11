import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/place.dart';

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

  static Future<List<Place>> fetchPlaces() async {
    try {
      final res = await _client.from('places').select().execute();
      if (res.error != null) return [];
      final data = (res.data as List).cast<Map<String, dynamic>>();
      return data.map((m) => Place.fromMap(m)).toList();
    } catch (e) {
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
      final res = await _client.from('places').insert(p.toMap()).execute();
      return res.error == null;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> uploadImage(String path, List<int> bytes) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final res =
          await _client.storage.from('places').uploadBinary(fileName, bytes);
      if (res.error != null) return null;
      final publicUrl =
          _client.storage.from('places').getPublicUrl(fileName).data;
      return publicUrl;
    } catch (e) {
      return null;
    }
  }
}
