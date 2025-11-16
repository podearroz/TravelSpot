import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelspot/core/theme/app_theme.dart';
import 'package:travelspot/generated/l10n/app_localizations.dart';
import 'package:travelspot/feature/places/domain/entity/place.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_bloc.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_state.dart';
import 'package:travelspot/feature/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:travelspot/feature/favorites/presentation/bloc/favorites_event.dart';
import 'package:travelspot/feature/favorites/presentation/bloc/favorites_state.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_state.dart';
import 'package:travelspot/feature/reviews/presentation/widget/reviews_modal.dart';
import 'package:travelspot/feature/reviews/presentation/bloc/reviews_bloc.dart';

class PlaceDetailsPage extends StatelessWidget {
  final String placeId;

  const PlaceDetailsPage({super.key, required this.placeId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, state) {
        Place? place;
        
        if (state is PlacesLoadedState) {
          try {
            place = state.places.firstWhere((p) => p.id == placeId);
          } catch (e) {
            // Place não encontrado
          }
        }

        if (place == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).details),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.paletteOf(Theme.of(context)).error(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).placeNotFound,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App bar com imagem
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      place.photoUrl != null
                          ? Hero(
                              tag: 'place_${place.id}',
                              child: Image.network(
                                place.photoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildImagePlaceholder(context);
                                },
                              ),
                            )
                          : _buildImagePlaceholder(context),
                      // Botão de favorito sobreposto
                      Positioned(
                        top: 56,
                        right: 8,
                        child: _buildFavoriteButton(context, place),
                      ),
                    ],
                  ),
                ),
              ),

              // Conteúdo
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome do local (título principal)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Text(
                        place.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),

                    // Tipo
                    if (place.placeType != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.place,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                place.placeType!.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Avaliação
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 24,
                            color: AppTheme.paletteOf(Theme.of(context)).warning(),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            place.averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${place.reviewCount} ${place.reviewCount == 1 ? 'avaliação' : 'avaliações'})',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Descrição
                    if (place.description != null) ...[
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sobre',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.paletteOf(Theme.of(context)).textPrimary(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              place.description!,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Localização
                    if (place.address != null) ...[
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Localização',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.paletteOf(Theme.of(context)).textPrimary(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.paletteOf(Theme.of(context))
                                    .textSecondary()
                                    .withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.paletteOf(Theme.of(context))
                                      .textSecondary()
                                      .withOpacity(0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: AppTheme.paletteOf(Theme.of(context)).error(),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      place.address!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: AppTheme.paletteOf(Theme.of(context)).textPrimary(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Coordenadas
                    if (place.latitude != null && place.longitude != null) ...[
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.paletteOf(Theme.of(context))
                                .textSecondary()
                                .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.paletteOf(Theme.of(context))
                                  .textSecondary()
                                  .withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.my_location,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${place.latitude!.toStringAsFixed(4)}, ${place.longitude!.toStringAsFixed(4)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                  color: AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Cozinhas (se houver)
                    if (place.cuisines.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cozinhas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.paletteOf(Theme.of(context)).textPrimary(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: place.cuisines.map((cuisine) {
                                return Chip(
                                  label: Text(cuisine.name),
                                  backgroundColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Botão de avaliações
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) {
                                return BlocProvider.value(
                                  value: BlocProvider.of<ReviewsBloc>(context),
                                  child: ReviewsModal(
                                    placeId: place!.id,
                                    placeName: place.name,
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.rate_review),
                          label: Text(
                            place.reviewCount > 0
                                ? 'Ver ${place.reviewCount} ${place.reviewCount == 1 ? 'avaliação' : 'avaliações'}'
                                : 'Seja o primeiro a avaliar',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.paletteOf(Theme.of(context)).primary().withOpacity(0.3),
            AppTheme.paletteOf(Theme.of(context)).primary().withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 80,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context, Place place) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, favoritesState) {
        final favoriteIds = favoritesState is FavoritesLoadedState
            ? favoritesState.favorites.map((f) => f.placeId).toSet()
            : favoritesState is FavoritesLoadingItemState
                ? favoritesState.currentFavorites.map((f) => f.placeId).toSet()
                : <String>{};

        final isFavorite = favoriteIds.contains(place.id);
        final isLoadingThisItem = favoritesState is FavoritesLoadingItemState &&
            favoritesState.placeId == place.id;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            onPressed: isLoadingThisItem
                ? null
                : () => _toggleFavorite(context, place, isFavorite),
            icon: isLoadingThisItem
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite
                        ? AppTheme.paletteOf(Theme.of(context)).error()
                        : AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                  ),
          ),
        );
      },
    );
  }

  void _toggleFavorite(BuildContext context, Place place, bool isFavorite) {
    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).needsAuthentication),
          backgroundColor: AppTheme.paletteOf(Theme.of(context)).warning(),
        ),
      );
      return;
    }

    final userId = authState.user.id;

    if (isFavorite) {
      context.read<FavoritesBloc>().add(RemoveFavoriteEvent(userId, place.id));
    } else {
      context.read<FavoritesBloc>().add(AddFavoriteEvent(userId, place.id));
    }
  }
}
