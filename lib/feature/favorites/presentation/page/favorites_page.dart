import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travelspot/core/theme/app_theme.dart';
import 'package:travelspot/feature/favorites/domain/entity/favorite.dart';
import 'package:travelspot/feature/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:travelspot/feature/favorites/presentation/bloc/favorites_event.dart';
import 'package:travelspot/feature/favorites/presentation/bloc/favorites_state.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_event.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_state.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_bloc.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_state.dart';
import 'package:travelspot/feature/places/domain/entity/place.dart';
import 'package:travelspot/feature/places/presentation/page/place_details_page.dart';
import 'package:travelspot/feature/reviews/presentation/bloc/reviews_bloc.dart';
import 'package:travelspot/generated/l10n/app_localizations.dart';

class FavoritesPage extends StatefulWidget {
  final bool isBottomNavigation;

  const FavoritesPage({super.key, this.isBottomNavigation = false});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  void _toggleFavorite(Favorite favorite, bool isFavorite) {
    final authState = context.read<AuthBloc>().state;
    String? userId;
    if (authState is AuthAuthenticated) {
      userId = authState.user.id;
    }
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).needsAuthToFavorite),
          backgroundColor: Colors.orange,
        ),
      );
      print(
          '[FavoritesPage] Tentativa de favoritar/desfavoritar sem usuário autenticado.');
      return;
    }
    context.read<FavoritesBloc>().add(
          isFavorite
              ? RemoveFavoriteEvent(userId, favorite.placeId)
              : AddFavoriteEvent(userId, favorite.placeId),
        );
  }

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      // Carregar favoritos ao iniciar a página
      final authState = context.read<AuthBloc>().state;
      final supabaseUser = Supabase.instance.client.auth.currentUser;

      String? userId;
      if (authState is AuthAuthenticated) {
        userId = authState.user.id;
      } else if (supabaseUser != null) {
        userId = supabaseUser.id;
        // Disparar sincronização do estado quando há inconsistência
        context.read<AuthBloc>().add(AuthSyncRequested());
      }

      if (userId != null) {
        context.read<FavoritesBloc>().add(LoadUserFavoritesEvent(userId));
      }

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).myFavorites),
        automaticallyImplyLeading: !widget.isBottomNavigation,
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is FavoritesErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final authState = context.read<AuthBloc>().state;
                      final supabaseUser =
                          Supabase.instance.client.auth.currentUser;
                      String? userId;
                      if (authState is AuthAuthenticated) {
                        userId = authState.user.id;
                      } else if (supabaseUser != null) {
                        userId = supabaseUser.id;
                        context.read<AuthBloc>().add(AuthSyncRequested());
                      }
                      if (userId != null) {
                        context
                            .read<FavoritesBloc>()
                            .add(LoadUserFavoritesEvent(userId));
                      }
                    },
                    child: Text(AppLocalizations.of(context).tryAgain),
                  ),
                ],
              ),
            );
          }

          final favorites =
              state is FavoritesLoadedState ? state.favorites : <Favorite>[];

          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum favorito ainda',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Adicione lugares aos seus favoritos para vê-los aqui',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return BlocBuilder<PlacesBloc, PlacesState>(
            builder: (context, placesState) {
              final places = placesState is PlacesLoadedState
                  ? placesState.places
                  : <Place>[];

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];

                  // Buscar o place correspondente
                  Place? place;
                  try {
                    place = places.firstWhere((p) => p.id == favorite.placeId);
                  } catch (e) {
                    // Place não encontrado na lista
                  }

                  if (place == null) {
                    // Mostrar placeholder enquanto carrega ou se não encontrou
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'Place ID: ${favorite.placeId}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Favoritado em: ${_formatDate(favorite.createdAt)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }

                  // Card com as informações do place
                  final currentPlace = place;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => _navigateToDetails(context, currentPlace),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagem
                          if (currentPlace.photoUrl != null)
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    currentPlace.photoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildImagePlaceholder(context);
                                    },
                                  ),
                                  // Botão de remover favorito
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child:
                                        _buildFavoriteButton(context, favorite),
                                  ),
                                ],
                              ),
                            )
                          else
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  _buildImagePlaceholder(context),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child:
                                        _buildFavoriteButton(context, favorite),
                                  ),
                                ],
                              ),
                            ),
                          // Conteúdo
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        currentPlace.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color:
                                          AppTheme.paletteOf(Theme.of(context))
                                              .textSecondary(),
                                    ),
                                  ],
                                ),
                                if (currentPlace.placeType != null) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      currentPlace.placeType!.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 18,
                                      color:
                                          AppTheme.paletteOf(Theme.of(context))
                                              .warning(),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      currentPlace.averageRating
                                          .toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${currentPlace.reviewCount})',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.paletteOf(
                                                Theme.of(context))
                                            .textSecondary(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToDetails(BuildContext context, Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<PlacesBloc>()),
            BlocProvider.value(value: context.read<FavoritesBloc>()),
            BlocProvider.value(value: context.read<AuthBloc>()),
            BlocProvider.value(value: context.read<ReviewsBloc>()),
          ],
          child: PlaceDetailsPage(placeId: place.id),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.paletteOf(Theme.of(context)).primary().withOpacity(0.1),
            AppTheme.paletteOf(Theme.of(context)).primary().withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 64,
          color: AppTheme.paletteOf(Theme.of(context))
              .textSecondary()
              .withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context, Favorite favorite) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isLoadingThisItem = state is FavoritesLoadingItemState &&
            state.placeId == favorite.placeId;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: isLoadingThisItem
                ? null
                : () => _toggleFavorite(favorite, true),
            icon: isLoadingThisItem
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.favorite,
                    color: AppTheme.paletteOf(Theme.of(context)).error(),
                  ),
          ),
        );
      },
    );
  }

  void _removeFavorite(Favorite favorite) {
    // Pegar ID do usuário autenticado
    final authState = context.read<AuthBloc>().state;
    final supabaseUser = Supabase.instance.client.auth.currentUser;

    String? userId;
    if (authState is AuthAuthenticated) {
      userId = authState.user.id;
    } else if (supabaseUser != null) {
      userId = supabaseUser.id;
      // Disparar sincronização do estado quando há inconsistência
      context.read<AuthBloc>().add(AuthSyncRequested());
    }

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).needsAuthToRemoveFavorite),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context
        .read<FavoritesBloc>()
        .add(RemoveFavoriteEvent(userId, favorite.placeId));
  }
}
