import 'package:travelspot/core/functional/try.dart';
import 'package:travelspot/core/errors/failure.dart';
import 'package:travelspot/feature/favorites/domain/entity/favorite.dart';
import 'package:travelspot/feature/favorites/domain/repository/favorites_repository.dart';
import 'package:travelspot/feature/favorites/data/data_source/remote/favorites_remote_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource _remoteDataSource;

  FavoritesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Try<List<Favorite>>> getUserFavorites(String userId) async {
    try {
      final favorites = await _remoteDataSource.getUserFavorites(userId);
      return Success(favorites);
    } catch (e) {
      return Rejection(
          ServerFailure('Failed to get favorites: ${e.toString()}'));
    }
  }

  @override
  Future<Try<Favorite>> addFavorite(String userId, String placeId) async {
    try {
      final favorite = await _remoteDataSource.addFavorite(userId, placeId);
      return Success(favorite);
    } catch (e) {
      return Rejection(
          ServerFailure('Failed to add favorite: ${e.toString()}'));
    }
  }

  @override
  Future<Try<void>> removeFavorite(String userId, String placeId) async {
    try {
      await _remoteDataSource.removeFavorite(userId, placeId);
      return Success(null);
    } catch (e) {
      return Rejection(
          ServerFailure('Failed to remove favorite: ${e.toString()}'));
    }
  }

  @override
  Future<Try<bool>> isFavorite(String userId, String placeId) async {
    try {
      final isFavorite =
          await _remoteDataSource.checkIsFavorite(userId, placeId);
      return Success(isFavorite);
    } catch (e) {
      return Rejection(
          ServerFailure('Failed to check favorite: ${e.toString()}'));
    }
  }
}
