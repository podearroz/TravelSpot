import 'package:chopper/chopper.dart';
import '../../feature/auth/data/data_source/remote/auth_api.dart';
import '../../feature/places/data/data_source/remote/places_api.dart';
import 'detailed_logging_interceptor.dart';

class ApiClient {
  static const String baseUrl = 'https://your-api-base-url.com/api/v1';
  static ChopperClient? _client;

  static ChopperClient get client {
    if (_client == null) {
      _client = ChopperClient(
        baseUrl: Uri.parse(baseUrl),
        converter: const JsonConverter(),
        errorConverter: const JsonConverter(),
        interceptors: [
          DetailedLoggingInterceptor(),
        ],
      );
    }
    return _client!;
  }

  // Método para obter as APIs
  static AuthApi get authApi => AuthApi.create(client);
  static PlacesApi get placesApi => PlacesApi.create(client);

  static void dispose() {
    _client?.dispose();
    _client = null;
  }
}
