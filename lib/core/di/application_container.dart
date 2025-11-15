import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:travelspot/core/api/api_client.dart';
import 'package:travelspot/core/api/supabase_api_client.dart';
import 'package:travelspot/core/services/supabase_service.dart';
import 'package:travelspot/core/services/biometric_service.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/auth_api.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/auth_remote_data_source_impl.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/supabase_auth_api.dart';
import 'package:travelspot/feature/auth/data/repository/supabase_auth_repository_impl.dart';
import 'package:travelspot/feature/auth/domain/repository/auth_repository.dart';
import 'package:travelspot/feature/auth/domain/use_case/login_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/register_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/logout_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/get_current_user_use_case.dart';
import 'package:travelspot/feature/auth/domain/use_case/check_cached_user_use_case.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:travelspot/feature/places/data/data_source/remote/places_api.dart';

class ApplicationContainer {
  static final GetIt _getIt = GetIt.instance;

  static GetIt get instance => _getIt;

  static Future<void> init() async {
    // Core Services
    _getIt.registerLazySingleton<SupabaseService>(() => SupabaseService());
    _getIt.registerLazySingleton<BiometricService>(() => BiometricService());
    
    // API Clients
    _getIt.registerLazySingleton<ChopperClient>(() => ApiClient.client);
    
    // Supabase Auth API
    _getIt.registerLazySingleton<SupabaseAuthApi>(() => SupabaseApiClient.authApi);
    
    // Legacy Auth API (para compatibilidade)
    _getIt.registerLazySingleton<AuthApi>(() => ApiClient.authApi);
    
    // Places API  
    _getIt.registerLazySingleton<PlacesApi>(() => ApiClient.placesApi);

    // Data Sources
    _getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(_getIt<AuthApi>()),
    );

    // Repositories - Use Supabase Auth Repository as primary
    _getIt.registerLazySingleton<AuthRepository>(
      () => SupabaseAuthRepositoryImpl(_getIt<SupabaseAuthApi>()),
    );

    // Use Cases - Auth
    _getIt.registerLazySingleton(() => LoginUseCase(_getIt<AuthRepository>()));
    _getIt.registerLazySingleton(() => RegisterUseCase(_getIt<AuthRepository>()));
    _getIt.registerLazySingleton(() => LogoutUseCase(_getIt<AuthRepository>()));
    _getIt.registerLazySingleton(() => GetCurrentUserUseCase(_getIt<AuthRepository>()));
    _getIt.registerLazySingleton(() => CheckCachedUserUseCase(
          _getIt<AuthRepository>(),
          _getIt<BiometricService>(),
        ));

    // BLoCs
    _getIt.registerFactory(() => AuthBloc(
          loginUseCase: _getIt<LoginUseCase>(),
          registerUseCase: _getIt<RegisterUseCase>(),
          logoutUseCase: _getIt<LogoutUseCase>(),
          getCurrentUserUseCase: _getIt<GetCurrentUserUseCase>(),
          biometricService: _getIt<BiometricService>(),
        ));
  }

  static T resolve<T extends Object>() => _getIt<T>();

  static void reset() => _getIt.reset();
}