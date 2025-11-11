import 'package:dio/dio.dart';
import 'package:chopper/chopper.dart';

class ApiService {
  static final Dio dio = Dio();

  // Chopper client (esqueleto) - caso queira gerar services com chopper
  static final chopper = ChopperClient(
    baseUrl: '',
    services: [],
    converter: const JsonConverter(),
    client: null,
  );

  // Exemplo simples usando Dio
  static Future<Response> get(String url, {Map<String, dynamic>? query}) async {
    return dio.get(url, queryParameters: query);
  }
}
