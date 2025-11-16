import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/favorites/domain/repository/favorites_repository.dart';

class RemoveFavoriteUseCase {
  final FavoritesRepository _repository;

  RemoveFavoriteUseCase(this._repository);

  Future<Try<void>> call(String userId, String placeId) async {
    return await _repository.removeFavorite(userId, placeId);
  }
}
