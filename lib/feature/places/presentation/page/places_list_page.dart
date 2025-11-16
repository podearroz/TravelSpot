import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travelspot/core/theme/app_theme.dart';
import 'package:travelspot/generated/l10n/app_localizations.dart';
import 'package:travelspot/feature/places/domain/entity/place.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_bloc.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_event.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_state.dart';
import 'package:travelspot/feature/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:travelspot/feature/favorites/presentation/bloc/favorites_event.dart';
import 'package:travelspot/feature/favorites/presentation/bloc/favorites_state.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_event.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_state.dart';
import 'package:travelspot/feature/reviews/presentation/widget/reviews_modal.dart';
import 'package:travelspot/feature/reviews/presentation/bloc/reviews_bloc.dart';
import 'package:travelspot/feature/places/presentation/page/place_details_page.dart';

class PlacesListPage extends StatefulWidget {
  final bool isBottomNavigation;

  const PlacesListPage({super.key, this.isBottomNavigation = false});

  @override
  State<PlacesListPage> createState() => _PlacesListPageState();
}

class _PlacesListPageState extends State<PlacesListPage>
    with SingleTickerProviderStateMixin {
  bool _initialized = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      // Carregar lugares ao iniciar a página
      context.read<PlacesBloc>().add(LoadPlacesEvent());

      // Pegar ID do usuário para carregar favoritos
      final authState = context.read<AuthBloc>().state;
      final supabaseUser = Supabase.instance.client.auth.currentUser;

      String? userId;
      if (authState is AuthAuthenticated) {
        userId = authState.user.id;
      } else if (supabaseUser != null) {
        userId = supabaseUser.id;
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
      appBar: widget.isBottomNavigation
          ? AppBar(
              title: Text(AppLocalizations.of(context).places),
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.logout, color: AppTheme.paletteOf(Theme.of(context)).error()),
                tooltip: AppLocalizations.of(context).logout,
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                },
              ),
              actions: [
                // Removido o botão de adicionar
              ],
            )
          : AppBar(
              title: Text(AppLocalizations.of(context).places),
              leading: IconButton(
                icon: Icon(Icons.logout, color: AppTheme.paletteOf(Theme.of(context)).error()),
                tooltip: AppLocalizations.of(context).logout,
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/favorites');
                  },
                  icon: const Icon(Icons.favorite),
                  tooltip: AppLocalizations.of(context).myFavorites,
                ),
                // Removido o botão de adicionar
              ],
            ),
      body: BlocListener<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          if (state is FavoritesErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context).errorFavoriting(state.message)),
                backgroundColor: AppTheme.paletteOf(Theme.of(context)).error(),
              ),
            );
          }
        },
        child: BlocBuilder<PlacesBloc, PlacesState>(
          builder: (context, placesState) {
            if (placesState is PlacesLoadingState) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 3,
                itemBuilder: (context, index) => _buildShimmerCard(),
              );
            }

            if (placesState is PlacesErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppTheme.paletteOf(Theme.of(context)).error(),
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).errorLoadingPlaces,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      placesState.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PlacesBloc>().add(LoadPlacesEvent());
                      },
                      child: Text(AppLocalizations.of(context).tryAgain),
                    ),
                  ],
                ),
              );
            }

            final places = placesState is PlacesLoadedState
                ? placesState.places
                : <Place>[];

            if (places.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.place_outlined,
                      size: 64,
                      color: AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).noPlacesFound,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                      ),
                    ),
                  ],
                ),
              );
            }

            return BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, favoritesState) {
                final favoriteIds = favoritesState is FavoritesLoadedState
                    ? favoritesState.favorites.map((f) => f.placeId).toSet()
                    : favoritesState is FavoritesLoadingItemState
                        ? favoritesState.currentFavorites
                            .map((f) => f.placeId)
                            .toSet()
                        : <String>{};

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    final isFavorite = favoriteIds.contains(place.id);

                    // Verificar se este item específico está em loading
                    final isLoadingThisItem =
                        favoritesState is FavoritesLoadingItemState &&
                            favoritesState.placeId == place.id;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagem com aspect ratio 16:9 ou placeholder
                          GestureDetector(
                            onTap: place.photoUrl != null
                                ? () => _showImageDialog(context, place.photoUrl!, place.id)
                                : null,
                            child: Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: place.photoUrl != null
                                        ? Hero(
                                            tag: 'place_${place.id}',
                                            child: Image.network(
                                              place.photoUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return _buildImagePlaceholder();
                                              },
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return Container(
                                                  color: AppTheme.paletteOf(Theme.of(context))
                                                      .textSecondary()
                                                      .withOpacity(0.1),
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      value: loadingProgress.expectedTotalBytes != null
                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                              loadingProgress.expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : _buildImagePlaceholder(),
                                  ),
                                  // Botão de favorito sobreposto
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        onPressed: isLoadingThisItem
                                            ? null
                                            : () => _toggleFavorite(place, isFavorite),
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
                                                    : AppTheme.paletteOf(Theme.of(context))
                                                        .textSecondary(),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          
                          // Conteúdo do card
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Título e tipo
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        place.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                if (place.placeType != null) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      place.placeType!.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                                
                                const SizedBox(height: 12),
                                
                                // Avaliação
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 18,
                                      color: AppTheme.paletteOf(Theme.of(context)).warning(),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      place.averageRating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${place.reviewCount})',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                if (place.description != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    place.description!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                
                                if (place.address != null) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          place.address!,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppTheme.paletteOf(Theme.of(context))
                                                .textSecondary(),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                
                                const SizedBox(height: 12),
                                
                                // Botões de ação
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () async {
                                        await showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (ctx) {
                                            return BlocProvider.value(
                                              value: BlocProvider.of<ReviewsBloc>(context),
                                              child: ReviewsModal(
                                                placeId: place.id,
                                                placeName: place.name,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.rate_review_outlined, size: 18),
                                      label: Text(AppLocalizations.of(context).reviewLabel),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed: () => _viewPlaceDetails(place),
                                      icon: const Icon(Icons.info_outline, size: 18),
                                      label: Text(AppLocalizations.of(context).viewDetails),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Botão de teste de sessão expirada (REMOVER EM PRODUÇÃO)
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/session-expired',
                (route) => false,
              );
            },
            tooltip: 'Testar Sessão Expirada',
            heroTag: 'test_session',
            child: const Icon(Icons.bug_report),
          ),
          const SizedBox(height: 16),
          // Botão principal de adicionar place
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/add-place');
            },
            tooltip: 'Adicionar Local',
            heroTag: 'add_place',
            child: const Icon(Icons.add),
          ),
        ],
      ),
      // Remover qualquer BottomAppBar ou bottomNavigationBar manual daqui
    );
  }

  void _toggleFavorite(Place place, bool isFavorite) {
    final authState = context.read<AuthBloc>().state;
    
    print('🔍 _toggleFavorite chamado');
    print('🔍 Estado de autenticação: ${authState.runtimeType}');
    
    if (authState is! AuthAuthenticated) {
      print('❌ Usuário NÃO autenticado');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).needsAuthentication),
          backgroundColor: AppTheme.paletteOf(Theme.of(context)).warning(),
        ),
      );
      return;
    }

    final userId = authState.user.id;
    print('✅ Usuário autenticado: $userId');
    print('📍 Place ID: ${place.id}');
    print('❤️ isFavorite: $isFavorite');

    if (isFavorite) {
      print('🗑️ Removendo favorito...');
      context.read<FavoritesBloc>().add(RemoveFavoriteEvent(userId, place.id));
    } else {
      print('➕ Adicionando favorito...');
      context.read<FavoritesBloc>().add(AddFavoriteEvent(userId, place.id));
    }
  }

  void _viewPlaceDetails(Place place) {
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

  Widget _buildShimmerCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shimmer da imagem
          AspectRatio(
            aspectRatio: 16 / 9,
            child: AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey[300]!,
                        Colors.grey[100]!,
                        Colors.grey[300]!,
                      ],
                      stops: [
                        _shimmerController.value - 0.3,
                        _shimmerController.value,
                        _shimmerController.value + 0.3,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shimmer do título
                _buildShimmerBox(double.infinity, 20),
                const SizedBox(height: 12),
                // Shimmer do badge
                _buildShimmerBox(100, 24, borderRadius: 16),
                const SizedBox(height: 12),
                // Shimmer da avaliação
                _buildShimmerBox(120, 16),
                const SizedBox(height: 12),
                // Shimmer da descrição
                _buildShimmerBox(double.infinity, 14),
                const SizedBox(height: 8),
                _buildShimmerBox(200, 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height, {double borderRadius = 4}) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: [
                _shimmerController.value - 0.3,
                _shimmerController.value,
                _shimmerController.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder() {
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
          color: AppTheme.paletteOf(Theme.of(context)).textSecondary().withOpacity(0.3),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl, String placeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              // Imagem em tela cheia com Hero animation
              Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Hero(
                    tag: 'place_$placeId',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: AppTheme.paletteOf(Theme.of(context)).error(),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Erro ao carregar imagem',
                                  style: TextStyle(
                                    color: AppTheme.paletteOf(Theme.of(context)).textPrimary(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Botão de fechar
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}