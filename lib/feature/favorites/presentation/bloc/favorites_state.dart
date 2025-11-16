import 'package:equatable/equatable.dart';
import 'package:travelspot/feature/favorites/domain/entity/favorite.dart';

abstract class FavoritesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesInitialState extends FavoritesState {}

class FavoritesLoadingState extends FavoritesState {}

// Estado de loading para um item específico, mantendo a lista de favoritos
class FavoritesLoadingItemState extends FavoritesState {
  final String placeId;
  final List<Favorite> currentFavorites;

  FavoritesLoadingItemState(this.placeId, this.currentFavorites);

  @override
  List<Object?> get props => [placeId, currentFavorites];
}

class FavoritesLoadedState extends FavoritesState {
  final List<Favorite> favorites;

  FavoritesLoadedState(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class FavoriteAddedState extends FavoritesState {
  final Favorite favorite;

  FavoriteAddedState(this.favorite);

  @override
  List<Object?> get props => [favorite];
}

class FavoriteRemovedState extends FavoritesState {
  final String placeId;

  FavoriteRemovedState(this.placeId);

  @override
  List<Object?> get props => [placeId];
}

class FavoriteCheckState extends FavoritesState {
  final bool isFavorite;
  final String placeId;

  FavoriteCheckState(this.isFavorite, this.placeId);

  @override
  List<Object?> get props => [isFavorite, placeId];
}

class FavoritesErrorState extends FavoritesState {
  final String message;

  FavoritesErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
