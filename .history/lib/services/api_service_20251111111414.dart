import 'package:dio/dio.dart' as dio_pkg;
import 'package:chopper/chopper.dart' as chopper_pkg;

class ApiService {
  static final dio_pkg.Dio dio = dio_pkg.Dio();

  // Chopper client (esqueleto) - caso queira gerar services com chopper
  static final chopper_pkg.ChopperClient chopper = chopper_pkg.ChopperClient(
    baseUrl: Uri.parse('https://example.com'),
    services: [],
    converter: const chopper_pkg.JsonConverter(),
    client: null,
  );

  // Exemplo simples usando Dio
  static Future<dio_pkg.Response> get(String url, {Map<String, dynamic>? query}) async {
    return dio.get(url, queryParameters: query);
  }
}
