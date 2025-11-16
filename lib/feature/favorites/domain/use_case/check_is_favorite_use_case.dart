import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/feature/favorites/domain/repository/favorites_repository.dart';

class CheckIsFavoriteUseCase {
  final FavoritesRepository _repository;

  CheckIsFavoriteUseCase(this._repository);

  Future<Try<bool>> call(String userId, String placeId) async {
    return await _repository.isFavorite(userId, placeId);
  }
}
