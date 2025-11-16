import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travelspot/config.dart';
import 'package:travelspot/core/api/detailed_logging_interceptor.dart';
import 'package:travelspot/core/api/auth_error_interceptor.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/supabase_auth_api.dart';
import 'package:travelspot/feature/places/data/data_source/remote/supabase_places_api.dart';
import 'package:travelspot/feature/favorites/data/data_source/remote/supabase_favorites_api.dart';
import 'package:travelspot/feature/reviews/data/data_source/remote/supabase_reviews_api.dart';

/// Cliente REST consolidado para Supabase
/// Integra autenticação, places, favorites e token management
class SupabaseRestClient {
  static ChopperClient? _restClient;
  static ChopperClient? _authClient;
  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Define a chave de navegação global para o interceptor de erro
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  /// Cliente para endpoints REST (/rest/v1) - places, favorites, etc
  static ChopperClient get restClient {
    if (_restClient != null) return _restClient!;

    final interceptors = <Interceptor>[
      _SupabaseAuthInterceptor(),
      DetailedLoggingInterceptor(),
    ];

    // Adiciona interceptor de erro de autenticação se navigatorKey estiver disponível
    if (_navigatorKey != null) {
      interceptors.insert(0, AuthErrorInterceptor(_navigatorKey!));
    }

    _restClient = ChopperClient(
      baseUrl: Uri.parse('${Config.supabaseUrl}/rest/v1'),
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
      interceptors: interceptors,
    );

    return _restClient!;
  }

  /// Cliente para endpoints de Auth (/auth/v1) - login, register, etc
  static ChopperClient get authClient {
    if (_authClient != null) return _authClient!;

    _authClient = ChopperClient(
      baseUrl: Uri.parse('${Config.supabaseUrl}/auth/v1'),
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
      interceptors: [
        _SupabaseAuthOnlyInterceptor(),
        DetailedLoggingInterceptor(),
      ],
    );

    return _authClient!;
  }

  /// Cliente principal (para compatibilidade com DI)
  static ChopperClient get client => restClient;

  static SupabaseAuthApi get authApi => SupabaseAuthApi.create(authClient);
  static SupabasePlacesApi get placesApi =>
      SupabasePlacesApi.create(restClient);
  static SupabaseFavoritesApi get favoritesApi =>
      SupabaseFavoritesApi.create(restClient);
  static SupabaseReviewsApi get reviewsApi =>
      SupabaseReviewsApi.create(restClient);

  /// Verifica se há usuário autenticado
  static Future<bool> isAuthenticated() async {
    final session = Supabase.instance.client.auth.currentSession;
    return session != null;
  }

  /// Limpa os clientes para forçar recriação (útil após logout)
  static void reset() {
    _restClient?.dispose();
    _authClient?.dispose();
    _restClient = null;
    _authClient = null;
  }
}

/// Interceptor para endpoints REST (/rest/v1) - com token management
class _SupabaseAuthInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final headers = <String, String>{
      'apikey': Config.supabaseAnonKey,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Prefer': 'return=representation',
    };

    // Tentar obter token da sessão atual do Supabase
    final session = Supabase.instance.client.auth.currentSession;
    final userToken = session?.accessToken;

    if (userToken != null) {
      // Usuário autenticado - usar JWT token
      headers['Authorization'] = 'Bearer $userToken';
      print('[SupabaseAuthInterceptor] Usando JWT do usuário autenticado.');
    } else {
      // Usuário não logado - usar chave anônima
      headers['Authorization'] = 'Bearer ${Config.supabaseAnonKey}';
      print(
          '[SupabaseAuthInterceptor] Usuário não autenticado, usando chave anônima.');
    }

    final request = applyHeaders(chain.request, headers);
    return chain.proceed(request);
  }
}

/// Interceptor para endpoints de Auth (/auth/v1) - apenas apikey
class _SupabaseAuthOnlyInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final headers = <String, String>{
      'apikey': Config.supabaseAnonKey,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final request = applyHeaders(chain.request, headers);
    return chain.proceed(request);
  }
}
