import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:travelspot/config.dart';
import 'package:travelspot/feature/auth/data/data_source/remote/supabase_auth_api.dart';

class SupabaseApiClient {
  static ChopperClient? _client;

  static ChopperClient get client {
    if (_client == null) {
      _client = ChopperClient(
        baseUrl: Uri.parse(Config.supabaseUrl),
        converter: const JsonConverter(),
        errorConverter: const JsonConverter(),
        interceptors: [
          _SupabaseAuthInterceptor(),
          HttpLoggingInterceptor(),
        ],
      );
    }
    return _client!;
  }

  static SupabaseAuthApi get authApi => SupabaseAuthApi.create(client);

  static void dispose() {
    _client?.dispose();
    _client = null;
  }
}

class _SupabaseAuthInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final request = applyHeaders(
      chain.request,
      {
        'apikey': Config.supabaseAnonKey,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return chain.proceed(request);
  }
}