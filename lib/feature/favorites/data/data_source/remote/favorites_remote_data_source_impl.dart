import 'package:travelspot/feature/favorites/data/data_source/remote/favorites_remote_data_source.dart';
import 'package:travelspot/feature/favorites/data/data_source/remote/supabase_favorites_api.dart';
import 'package:travelspot/feature/favorites/domain/entity/favorite.dart';

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final SupabaseFavoritesApi _api;

  FavoritesRemoteDataSourceImpl(this._api);

  @override
  Future<List<Favorite>> getUserFavorites(String userId) async {
    try {
      final response = await _api.getUserFavorites(
        'eq.$userId',
        'user_id,place_id,created_at',
      );

      print('Favorites API Response - Status: ${response.statusCode}');
      print('Favorites API Response - Body: ${response.body}');

      if (response.isSuccessful && response.body != null) {
        final data = response.body!;

        try {
          // Se é uma lista direta
          if (data is List) {
            print('✅ Parsing ${data.length} favorites from list');
            final favorites = <Favorite>[];
            for (var i = 0; i < data.length; i++) {
              try {
                final json = data[i] as Map<String, dynamic>;
                print('Parsing favorite $i: $json');
                final favorite = Favorite.fromJson(json);
                favorites.add(favorite);
              } catch (e, stackTrace) {
                print('❌ Error parsing favorite at index $i: $e');
                print('StackTrace: $stackTrace');
              }
            }
            return favorites;
          }

          // Se é um Map com dados encapsulados
          if (data is Map<String, dynamic> && data.containsKey('data')) {
            final list = data['data'] as List;
            print('✅ Parsing ${list.length} favorites from map.data');
            final favorites = <Favorite>[];
            for (var i = 0; i < list.length; i++) {
              try {
                final json = list[i] as Map<String, dynamic>;
                print('Parsing favorite $i: $json');
                final favorite = Favorite.fromJson(json);
                favorites.add(favorite);
              } catch (e, stackTrace) {
                print('❌ Error parsing favorite at index $i: $e');
                print('StackTrace: $stackTrace');
              }
            }
            return favorites;
          }
        } catch (e, stackTrace) {
          print('❌ Error in parsing logic: $e');
          print('StackTrace: $stackTrace');
          rethrow;
        }

        // Retorna lista vazia se não encontrar formato esperado
        print('⚠️ Unexpected data format, returning empty list');
        return [];
      }

      throw Exception(
          'Failed to get favorites: Status ${response.statusCode}, Body: ${response.body}');
    } catch (e, stackTrace) {
      print('Error getting user favorites: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Error getting favorites: $e');
    }
  }

  @override
  Future<Favorite> addFavorite(String userId, String placeId) async {
    final favoriteData = {
      'user_id': userId,
      'place_id': placeId,
    };

    final response = await _api.addFavorite(favoriteData);

    print('🔍 Add Favorite API Response - Status: ${response.statusCode}');
    print('🔍 Add Favorite API Response - Body: ${response.body}');

    // 409 = Conflict (favorito já existe) - tratar como sucesso
    if (response.statusCode == 409) {
      print('⚠️ Favorite already exists - treating as success');
      return Favorite(
        userId: userId,
        placeId: placeId,
        createdAt: DateTime.now(),
        place: null,
      );
    }

    if (response.isSuccessful) {
      if (response.body == null) {
        // Supabase pode retornar null em caso de sucesso sem retorno
        print('✅ Add favorite successful - no body returned');
        return Favorite(
          userId: userId,
          placeId: placeId,
          createdAt: DateTime.now(),
          place: null,
        );
      }

      final data = response.body!;

      try {
        // Se é uma lista com o item criado
        if (data is List && data.isNotEmpty) {
          return Favorite.fromJson(data.first as Map<String, dynamic>);
        }

        // Se é um Map
        if (data is Map<String, dynamic>) {
          // Verifica se tem dados encapsulados
          if (data.containsKey('data')) {
            final itemData = data['data'];
            if (itemData is List && itemData.isNotEmpty) {
              return Favorite.fromJson(itemData.first as Map<String, dynamic>);
            } else if (itemData is Map<String, dynamic>) {
              return Favorite.fromJson(itemData);
            }
          } else {
            // Tenta fazer parse direto
            return Favorite.fromJson(data);
          }
        }
      } catch (parseError) {
        print('⚠️ Parse error, creating minimal favorite: $parseError');
      }

      // Fallback: Cria o favorito com os dados mínimos
      return Favorite(
        userId: userId,
        placeId: placeId,
        createdAt: DateTime.now(),
        place: null,
      );
    }

    throw Exception(
        'Failed to add favorite: Status ${response.statusCode}, Body: ${response.body}');
  }

  @override
  Future<void> removeFavorite(String userId, String placeId) async {
    try {
      final response = await _api.removeFavorite('eq.$userId', 'eq.$placeId');

      print('Remove Favorite API Response - Status: ${response.statusCode}');
      print('Remove Favorite API Response - Body: ${response.body}');

      if (!response.isSuccessful) {
        throw Exception(
            'Failed to remove favorite: Status ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error removing favorite: $e');
      throw Exception('Error removing favorite: $e');
    }
  }

  @override
  Future<bool> checkIsFavorite(String userId, String placeId) async {
    try {
      final response = await _api.checkIsFavorite('eq.$userId', 'eq.$placeId');

      print('Check Favorite API Response - Status: ${response.statusCode}');
      print('Check Favorite API Response - Body: ${response.body}');

      if (response.isSuccessful && response.body != null) {
        final data = response.body!;

        // Se é uma lista, verifica se não está vazia
        if (data is List) {
          return data.isNotEmpty;
        }

        // Se é um Map com dados encapsulados
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final list = data['data'] as List;
          return list.isNotEmpty;
        }
      }

      return false;
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }
}
