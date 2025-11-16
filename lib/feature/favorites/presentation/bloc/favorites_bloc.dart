import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelspot/feature/favorites/domain/entity/favorite.dart';
import 'package:travelspot/feature/favorites/domain/use_case/add_favorite_use_case.dart';
import 'package:travelspot/feature/favorites/domain/use_case/remove_favorite_use_case.dart';
import 'package:travelspot/feature/favorites/domain/use_case/get_user_favorites_use_case.dart';
import 'package:travelspot/feature/favorites/domain/use_case/check_is_favorite_use_case.dart';
import 'package:travelspot/feature/favorites/presentation/bloc/favorites_event.dart';
import 'package:travelspot/feature/favorites/presentation/bloc/favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final AddFavoriteUseCase _addFavoriteUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;
  final GetUserFavoritesUseCase _getUserFavoritesUseCase;
  final CheckIsFavoriteUseCase _checkIsFavoriteUseCase;

  FavoritesBloc({
    required AddFavoriteUseCase addFavoriteUseCase,
    required RemoveFavoriteUseCase removeFavoriteUseCase,
    required GetUserFavoritesUseCase getUserFavoritesUseCase,
    required CheckIsFavoriteUseCase checkIsFavoriteUseCase,
  })  : _addFavoriteUseCase = addFavoriteUseCase,
        _removeFavoriteUseCase = removeFavoriteUseCase,
        _getUserFavoritesUseCase = getUserFavoritesUseCase,
        _checkIsFavoriteUseCase = checkIsFavoriteUseCase,
        super(FavoritesInitialState()) {
    on<LoadUserFavoritesEvent>(_onLoadUserFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<CheckIsFavoriteEvent>(_onCheckIsFavorite);
  }

  Future<void> _onLoadUserFavorites(
      LoadUserFavoritesEvent event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoadingState());

    final result = await _getUserFavoritesUseCase(event.userId);

    result.fold(
      (failure) => emit(FavoritesErrorState(failure.error)),
      (favorites) => emit(FavoritesLoadedState(favorites)),
    );
  }

  Future<void> _onAddFavorite(
      AddFavoriteEvent event, Emitter<FavoritesState> emit) async {
    print(
        '🎯 AddFavorite event received - UserId: ${event.userId}, PlaceId: ${event.placeId}');

    // Pegar a lista atual de favoritos antes de emitir loading
    final currentFavorites = state is FavoritesLoadedState
        ? (state as FavoritesLoadedState).favorites
        : <Favorite>[];

    // Emitir loading apenas para este item específico
    emit(FavoritesLoadingItemState(event.placeId, currentFavorites));

    final result = await _addFavoriteUseCase(event.userId, event.placeId);

    await result.fold(
      (failure) async {
        print('❌ AddFavorite failed: ${failure.error}');
        emit(FavoritesErrorState(failure.error));
      },
      (favorite) async {
        print('✅ AddFavorite success: ${favorite.placeId}');
        // Recarregar a lista de favoritos após adicionar
        final favoritesResult = await _getUserFavoritesUseCase(event.userId);
        if (!emit.isDone) {
          favoritesResult.fold(
            (failure) => emit(FavoritesErrorState(failure.error)),
            (favorites) => emit(FavoritesLoadedState(favorites)),
          );
        }
      },
    );
  }

  Future<void> _onRemoveFavorite(
      RemoveFavoriteEvent event, Emitter<FavoritesState> emit) async {
    print(
        '🗑️ RemoveFavorite event received - UserId: ${event.userId}, PlaceId: ${event.placeId}');

    // Pegar a lista atual de favoritos antes de emitir loading
    final currentFavorites = state is FavoritesLoadedState
        ? (state as FavoritesLoadedState).favorites
        : <Favorite>[];

    // Emitir loading apenas para este item específico
    emit(FavoritesLoadingItemState(event.placeId, currentFavorites));

    final result = await _removeFavoriteUseCase(event.userId, event.placeId);

    await result.fold(
      (failure) async {
        print('❌ RemoveFavorite failed: ${failure.error}');
        emit(FavoritesErrorState(failure.error));
      },
      (_) async {
        print('✅ RemoveFavorite success for place: ${event.placeId}');
        // Recarregar a lista de favoritos após remover
        final favoritesResult = await _getUserFavoritesUseCase(event.userId);
        if (!emit.isDone) {
          favoritesResult.fold(
            (failure) => emit(FavoritesErrorState(failure.error)),
            (favorites) => emit(FavoritesLoadedState(favorites)),
          );
        }
      },
    );
  }

  Future<void> _onCheckIsFavorite(
      CheckIsFavoriteEvent event, Emitter<FavoritesState> emit) async {
    final result = await _checkIsFavoriteUseCase(event.userId, event.placeId);

    result.fold(
      (failure) => emit(FavoritesErrorState(failure.error)),
      (isFavorite) => emit(FavoriteCheckState(isFavorite, event.placeId)),
    );
  }
}
