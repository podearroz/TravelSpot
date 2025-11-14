import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:travelspot/core/api/api_client.dart';
import 'package:travelspot/core/services/supabase_service.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/auth_api.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/auth_remote_data_source_impl.dart';
import 'package:travelspot/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:travelspot/feature/auth/domain/repository/auth_repository.dart';
import 'package:travelspot/feature/auth/domain/use_case/login_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/register_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/logout_use_case.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:travelspot/feature/places/data/data_source/remote/places_api.dart';

class ApplicationContainer {
  static final GetIt _getIt = GetIt.instance;

  static GetIt get instance => _getIt;

  static Future<void> init() async {
    // Core Services
    _getIt.registerLazySingleton<SupabaseService>(() => SupabaseService());
    
    // Core API Client
    _getIt.registerLazySingleton<ChopperClient>(() => ApiClient.client);
    
    // Auth API
    _getIt.registerLazySingleton<AuthApi>(() => ApiClient.authApi);
    
    // Places API  
    _getIt.registerLazySingleton<PlacesApi>(() => ApiClient.placesApi);

    // Data Sources
    _getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(_getIt<AuthApi>()),
    );

    // Repositories
    _getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(_getIt<AuthRemoteDataSource>()),
    );

    // Use Cases - Auth
    _getIt.registerLazySingleton(() => LoginUseCase(_getIt<AuthRepository>()));
    _getIt.registerLazySingleton(() => RegisterUseCase(_getIt<AuthRepository>()));
    _getIt.registerLazySingleton(() => LogoutUseCase(_getIt<AuthRepository>()));

    // BLoCs
    _getIt.registerFactory(() => AuthBloc(
          loginUseCase: _getIt<LoginUseCase>(),
          registerUseCase: _getIt<RegisterUseCase>(),
          logoutUseCase: _getIt<LogoutUseCase>(),
        ));
  }

  static T resolve<T extends Object>() => _getIt<T>();

  static void reset() => _getIt.reset();
}