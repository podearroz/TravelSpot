import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:travelspot/core/api/supabase_rest_client.dart';
import 'package:travelspot/core/services/local_storage_service.dart';
import 'package:travelspot/core/services/supabase_service.dart';
import 'package:travelspot/core/services/biometric_service.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/supabase_auth_api.dart';
import 'package:travelspot/feature/auth/data/repository/supabase_auth_repository_impl.dart';
import 'package:travelspot/feature/auth/domain/repository/auth_repository.dart';
import 'package:travelspot/feature/auth/domain/use_case/login_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/register_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/logout_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/get_current_user_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/check_cached_user_use_case.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_bloc.dart';

// Places imports
import 'package:travelspot/feature/places/data/data_source/remote/supabase_places_api.dart';
import 'package:travelspot/feature/places/data/data_source/remote/places_remote_data_source.dart';
import 'package:travelspot/feature/places/data/data_source/remote/places_remote_data_source_impl.dart';
import 'package:travelspot/feature/places/data/repository/places_repository_impl.dart';
import 'package:travelspot/feature/places/domain/repository/places_repository.dart';
import 'package:travelspot/feature/places/domain/use_case/add_place_use_case.dart';
import 'package:travelspot/feature/places/domain/use_case/get_place_types_use_case.dart';
import 'package:travelspot/feature/places/domain/use_case/get_cuisines_use_case.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_bloc.dart';

// Favorites imports
import 'package:travelspot/feature/favorites/data/data_source/remote/supabase_favorites_api.dart';
import 'package:travelspot/feature/favorites/data/data_source/remote/favorites_remote_data_source.dart';
import 'package:travelspot/feature/favorites/data/data_source/remote/favorites_remote_data_source_impl.dart';
import 'package:travelspot/feature/favorites/data/repository/favorites_repository_impl.dart';
import 'package:travelspot/feature/favorites/domain/repository/favorites_repository.dart';
import 'package:travelspot/feature/favorites/domain/use_case/add_favorite_use_case.dart';
import 'package:travelspot/feature/favorites/domain/use_case/remove_favorite_use_case.dart';
import 'package:travelspot/feature/favorites/domain/use_case/get_user_favorites_use_case.dart';
import 'package:travelspot/feature/favorites/domain/use_case/check_is_favorite_use_case.dart';
import 'package:travelspot/feature/favorites/presentation/bloc/favorites_bloc.dart';

// Reviews imports
import 'package:travelspot/feature/reviews/data/data_source/remote/supabase_reviews_api.dart';
import 'package:travelspot/feature/reviews/data/data_source/remote/reviews_remote_data_source.dart';
import 'package:travelspot/feature/reviews/data/data_source/remote/reviews_remote_data_source_impl.dart';
import 'package:travelspot/feature/reviews/data/repository/review_repository_impl.dart';
import 'package:travelspot/feature/reviews/domain/repository/review_repository.dart';
import 'package:travelspot/feature/reviews/domain/use_case/add_review_use_case.dart';
import 'package:travelspot/feature/reviews/domain/use_case/get_place_reviews_use_case.dart';
import 'package:travelspot/feature/reviews/presentation/bloc/reviews_bloc.dart';

class ApplicationContainer {
  static final GetIt _getIt = GetIt.instance;

  static GetIt get instance => _getIt;

  static Future<void> init() async {
    // Core Services
    _getIt.registerLazySingleton<SupabaseService>(() => SupabaseService());
    _getIt.registerLazySingleton<BiometricService>(() => BiometricService());
    _getIt.registerLazySingleton<LocalStorageService>(() => LocalStorageService());
    _getIt.registerLazySingleton<supabase.SupabaseClient>(() => supabase.Supabase.instance.client);


    // API Client Único - Supabase (consolida tudo)
    _getIt
        .registerLazySingleton<ChopperClient>(() => SupabaseRestClient.client);

    // APIs Supabase (todas através do cliente consolidado)
    _getIt.registerLazySingleton<SupabaseAuthApi>(
        () => SupabaseRestClient.authApi);
    _getIt.registerLazySingleton<SupabasePlacesApi>(
        () => SupabaseRestClient.placesApi);
    _getIt.registerLazySingleton<SupabaseFavoritesApi>(
        () => SupabaseRestClient.favoritesApi);
    _getIt.registerLazySingleton<SupabaseReviewsApi>(
        () => SupabaseRestClient.reviewsApi);

    // Repository - Auth (Supabase único)
    _getIt.registerLazySingleton<AuthRepository>(
      () => SupabaseAuthRepositoryImpl(
        _getIt<SupabaseAuthApi>(),
        _getIt<LocalStorageService>(),
        _getIt<supabase.SupabaseClient>(),
      ),
    );

    // Use Cases - Auth
    _getIt.registerLazySingleton(() => LoginUseCase(_getIt<AuthRepository>()));
    _getIt
        .registerLazySingleton(() => RegisterUseCase(_getIt<AuthRepository>()));
    _getIt.registerLazySingleton(() => LogoutUseCase(_getIt<AuthRepository>()));
    _getIt.registerLazySingleton(
        () => GetCurrentUserUseCase(_getIt<AuthRepository>()));
    _getIt.registerLazySingleton(() => CheckCachedUserUseCase(
          _getIt<AuthRepository>(),
          _getIt<BiometricService>(),
          _getIt<LocalStorageService>(),
        ));

    // Data Sources - Places
    _getIt.registerLazySingleton<PlacesRemoteDataSource>(
      () => PlacesRemoteDataSourceImpl(_getIt<SupabasePlacesApi>()),
    );

    // Data Sources - Favorites
    _getIt.registerLazySingleton<FavoritesRemoteDataSource>(
      () => FavoritesRemoteDataSourceImpl(_getIt<SupabaseFavoritesApi>()),
    );

    // Data Sources - Reviews
    _getIt.registerLazySingleton<ReviewsRemoteDataSource>(
      () => ReviewsRemoteDataSourceImpl(_getIt<SupabaseReviewsApi>()),
    );

    // Repositories - Places
    _getIt.registerLazySingleton<PlacesRepository>(
      () => PlacesRepositoryImpl(_getIt<PlacesRemoteDataSource>()),
    );

    // Repositories - Favorites
    _getIt.registerLazySingleton<FavoritesRepository>(
      () => FavoritesRepositoryImpl(_getIt<FavoritesRemoteDataSource>()),
    );

    // Repositories - Reviews
    _getIt.registerLazySingleton<ReviewRepository>(
      () => ReviewRepositoryImpl(_getIt<ReviewsRemoteDataSource>()),
    );

    // Use Cases - Places
    _getIt.registerLazySingleton(
        () => AddPlaceUseCase(_getIt<PlacesRepository>()));
    _getIt.registerLazySingleton(
        () => GetPlaceTypesUseCase(_getIt<PlacesRepository>()));
    _getIt.registerLazySingleton(
        () => GetCuisinesUseCase(_getIt<PlacesRepository>()));

    // Use Cases - Favorites
    _getIt.registerLazySingleton(
        () => AddFavoriteUseCase(_getIt<FavoritesRepository>()));
    _getIt.registerLazySingleton(
        () => RemoveFavoriteUseCase(_getIt<FavoritesRepository>()));
    _getIt.registerLazySingleton(
        () => GetUserFavoritesUseCase(_getIt<FavoritesRepository>()));
    _getIt.registerLazySingleton(
        () => CheckIsFavoriteUseCase(_getIt<FavoritesRepository>()));

    // Use Cases - Reviews
    _getIt.registerLazySingleton(
        () => GetPlaceReviewsUseCase(_getIt<ReviewRepository>()));
    _getIt.registerLazySingleton(
        () => AddReviewUseCase(_getIt<ReviewRepository>()));

    // BLoCs
    _getIt.registerFactory(() => AuthBloc(
          loginUseCase: _getIt<LoginUseCase>(),
          registerUseCase: _getIt<RegisterUseCase>(),
          logoutUseCase: _getIt<LogoutUseCase>(),
          getCurrentUserUseCase: _getIt<GetCurrentUserUseCase>(),
          checkCachedUserUseCase: _getIt<CheckCachedUserUseCase>(),
          biometricService: _getIt<BiometricService>(),
        ));

    _getIt.registerFactory(() => PlacesBloc(
          repository: _getIt<PlacesRepository>(),
          addPlaceUseCase: _getIt<AddPlaceUseCase>(),
          getPlaceTypesUseCase: _getIt<GetPlaceTypesUseCase>(),
          getCuisinesUseCase: _getIt<GetCuisinesUseCase>(),
        ));

    _getIt.registerFactory(() => FavoritesBloc(
          addFavoriteUseCase: _getIt<AddFavoriteUseCase>(),
          removeFavoriteUseCase: _getIt<RemoveFavoriteUseCase>(),
          getUserFavoritesUseCase: _getIt<GetUserFavoritesUseCase>(),
          checkIsFavoriteUseCase: _getIt<CheckIsFavoriteUseCase>(),
        ));

    _getIt.registerFactory(() => ReviewsBloc(
          getPlaceReviewsUseCase: _getIt<GetPlaceReviewsUseCase>(),
          addReviewUseCase: _getIt<AddReviewUseCase>(),
          placesBloc: _getIt<PlacesBloc>(),
        ));
  }

  static T resolve<T extends Object>() => _getIt<T>();

  static void reset() => _getIt.reset();
}
