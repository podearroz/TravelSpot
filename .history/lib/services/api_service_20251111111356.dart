import 'package:dio/dio.dart' as dio;
import 'package:chopper/chopper.dart' as chopper;

class ApiService {
  static final dio.Dio dio = dio.Dio();

  // Chopper client (esqueleto) - caso queira gerar services com chopper
  static final chopper.ChopperClient chopper = chopper.ChopperClient(
    baseUrl: Uri.parse('https://example.com'),
    services: [],
    converter: const chopper.JsonConverter(),
    client: null,
  );

  // Exemplo simples usando Dio
  static Future<dio.Response> get(String url, {Map<String, dynamic>? query}) async {
    return dio.get(url, queryParameters: query);
  }
}
