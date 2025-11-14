import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:logging/logging.dart';

class DetailedLoggingInterceptor implements Interceptor {
  final Logger _logger = Logger('HTTP');

  @override
  Future<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final request = chain.request;
    final method = request.method.toUpperCase();
    final url = request.url;
    final headers = request.headers;
    final body = request.body;

    // Log do request completo
    _logger
        .info('┌─────────────────────────────────────────────────────────────');
    _logger.info('│ REQUEST');
    _logger
        .info('├─────────────────────────────────────────────────────────────');
    _logger.info('│ Method: $method');
    _logger.info('│ URL: $url');
    _logger.info('│ Headers:');

    headers.forEach((key, value) {
      _logger.info('│   $key: $value');
    });

    if (body != null) {
      _logger.info('│ Body:');
      try {
        // Tenta formatar JSON
        if (body is String) {
          final decoded = jsonDecode(body);
          final prettyJson =
              const JsonEncoder.withIndent('  ').convert(decoded);
          _logger.info('│   $prettyJson');
        } else {
          _logger.info('│   $body');
        }
      } catch (e) {
        _logger.info('│   $body');
      }
    }

    // Log formato CURL
    _logger.info('│ CURL:');
    String curl = 'curl -X $method';

    headers.forEach((key, value) {
      curl += ' -H "$key: $value"';
    });

    if (body != null) {
      curl += ' -d \'$body\'';
    }

    curl += ' "$url"';
    _logger.info('│   $curl');
    _logger
        .info('└─────────────────────────────────────────────────────────────');

    // Executa a requisição
    final response = await chain.proceed(request);

    // Log do response completo
    final statusCode = response.statusCode;
    final responseHeaders = response.headers;
    final responseBody = response.body;

    _logger
        .info('┌─────────────────────────────────────────────────────────────');
    _logger.info('│ RESPONSE');
    _logger
        .info('├─────────────────────────────────────────────────────────────');
    _logger.info('│ Status Code: $statusCode');
    _logger.info('│ Headers:');

    responseHeaders.forEach((key, value) {
      _logger.info('│   $key: $value');
    });

    if (responseBody != null) {
      _logger.info('│ Body:');
      try {
        // Tenta formatar JSON
        if (responseBody is String) {
          final decoded = jsonDecode(responseBody);
          final prettyJson =
              const JsonEncoder.withIndent('  ').convert(decoded);
          _logger.info('│   $prettyJson');
        } else if (responseBody is Map || responseBody is List) {
          final prettyJson =
              const JsonEncoder.withIndent('  ').convert(responseBody);
          _logger.info('│   $prettyJson');
        } else {
          _logger.info('│   $responseBody');
        }
      } catch (e) {
        _logger.info('│   $responseBody');
      }
    }

    _logger
        .info('└─────────────────────────────────────────────────────────────');

    return response;
  }
}
