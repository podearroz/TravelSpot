import 'package:equatable/equatable.dart';
import 'package:travelspot/feature/favorites/domain/entity/favorite.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserFavoritesEvent extends FavoritesEvent {
  final String userId;

  LoadUserFavoritesEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddFavoriteEvent extends FavoritesEvent {
  final String userId;
  final String placeId;

  AddFavoriteEvent(this.userId, this.placeId);

  @override
  List<Object?> get props => [userId, placeId];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final String userId;
  final String placeId;

  RemoveFavoriteEvent(this.userId, this.placeId);

  @override
  List<Object?> get props => [userId, placeId];
}

class CheckIsFavoriteEvent extends FavoritesEvent {
  final String userId;
  final String placeId;

  CheckIsFavoriteEvent(this.userId, this.placeId);

  @override
  List<Object?> get props => [userId, placeId];
}
