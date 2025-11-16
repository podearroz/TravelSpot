import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/favorites/domain/entity/favorite.dart';
import 'package:travelspot/feature/favorites/domain/repository/favorites_repository.dart';

class AddFavoriteUseCase {
  final FavoritesRepository _repository;

  AddFavoriteUseCase(this._repository);

  Future<Try<Favorite>> call(String userId, String placeId) async {
    return await _repository.addFavorite(userId, placeId);
  }
}
