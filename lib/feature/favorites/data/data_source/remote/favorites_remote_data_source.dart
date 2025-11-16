import 'package:travelspot/feature/favorites/domain/entity/favorite.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<Favorite>> getUserFavorites(String userId);
  Future<Favorite> addFavorite(String userId, String placeId);
  Future<void> removeFavorite(String userId, String placeId);
  Future<bool> checkIsFavorite(String userId, String placeId);
}
