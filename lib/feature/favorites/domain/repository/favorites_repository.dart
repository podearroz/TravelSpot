import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/favorites/domain/entity/favorite.dart';

abstract class FavoritesRepository {
  Future<Try<List<Favorite>>> getUserFavorites(String userId);
  Future<Try<Favorite>> addFavorite(String userId, String placeId);
  Future<Try<void>> removeFavorite(String userId, String placeId);
  Future<Try<bool>> isFavorite(String userId, String placeId);
}
