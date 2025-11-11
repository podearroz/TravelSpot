import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/place.dart';

class SupabaseService {
  static final _client = Supabase.instance.client;

  // Inicialização: configure SUPABASE_URL e SUPABASE_ANON_KEY no README
  static Future<void> initialize() async {
    // Caso queira inicializar aqui: Supabase.initialize(...)
    // Por enquanto esperamos que Supabase seja inicializado externamente
  }

  static Future<List<Place>> fetchPlaces() async {
    try {
      // Exemplo: buscar tabela 'places' no Supabase
      final res = await _client.from('places').select().execute();
      if (res.error != null) return [];
      final data = (res.data as List).cast<Map<String, dynamic>>();
      return data.map((m) => Place.fromMap(m)).toList();
    } catch (e) {
      // Em caso de ambiente sem Supabase configurado, retornar lista mock
      return [
        Place(id: '1', name: 'Café Central', type: 'Café', cuisine: 'Cafeteria', description: 'Ótimo para um café e doce.', imageUrl: null),
        Place(id: '2', name: 'Restaurante do Porto', type: 'Restaurante', cuisine: 'Peixe', description: 'Frutos do mar frescos.', imageUrl: null),
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
      final res = await _client.storage.from('places').uploadBinary(fileName, bytes);
      if (res.error != null) return null;
      final publicUrl = _client.storage.from('places').getPublicUrl(fileName).data;
      return publicUrl;
    } catch (e) {
      return null;
    }
  }
}
