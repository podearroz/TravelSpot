import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/favorites/domain/entity/favorite.dart';
import 'package:travelspot/feature/favorites/domain/repository/favorites_repository.dart';

class GetUserFavoritesUseCase {
  final FavoritesRepository _repository;

  GetUserFavoritesUseCase(this._repository);

  Future<Try<List<Favorite>>> call(String userId) async {
    return await _repository.getUserFavorites(userId);
  }
}
