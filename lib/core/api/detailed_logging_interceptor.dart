import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:logging/logging.dart';

class DetailedLoggingInterceptor implements Interceptor {
  final Logger _logger = Logger('HTTP');

  @override
  Future<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final request = chain.request;

    _logRequest(request);
    _generateAndPrintCurl(request);

    final response = await chain.proceed(request);

    _logResponse(response);

    return response;
  }

  void _logRequest(Request request) {
    final method = request.method.toUpperCase();
    final url = request.uri;
    final headers = request.headers;
    final body = request.body;

    _logger.info('┌──────────────── Request ────────────────┐');
    _logger.info('│ Method: $method');
    _logger.info('│ URL: $url');
    _logger.info('│ Headers:');
    headers.forEach((key, value) => _logger.info('│   $key: $value'));

    if (body != null) {
      _logger.info('│ Body:');
      try {
        final prettyJson = const JsonEncoder.withIndent('  ').convert(body);
        _logger.info(prettyJson.split('\n').map((l) => '│   $l').join('\n'));
      } catch (e) {
        _logger.info('│   $body');
      }
    }
    _logger.info('└─────────────────────────────────────────┘');
  }

  void _logResponse(Response response) {
    final statusCode = response.statusCode;
    final headers = response.headers;
    final body = response.body;

    _logger.info('┌──────────────── Response ($statusCode) ────────────────┐');
    _logger.info('│ Headers:');
    headers.forEach((key, value) => _logger.info('│   $key: $value'));

    if (body != null) {
      _logger.info('│ Body:');
      try {
        dynamic bodyToLog = body;
        if (body is String && body.isNotEmpty) {
          bodyToLog = jsonDecode(body);
        }
        final prettyJson = const JsonEncoder.withIndent('  ').convert(bodyToLog);
        _logger.info(prettyJson.split('\n').map((l) => '│   $l').join('\n'));
      } catch (e) {
        _logger.info('│   $body');
      }
    }
    _logger.info('└──────────────────────────────────────────┘');
  }

  void _generateAndPrintCurl(Request request) {
    final method = request.method.toUpperCase();
    final url = request.uri;
    final headers = request.headers;
    final body = request.body;

    final curlParts = <String>['curl -X $method'];

    headers.forEach((key, value) {
      curlParts.add(' \\\n  -H "$key: $value"');
    });

    if (body != null) {
      String bodyAsString;
      try {
        bodyAsString = jsonEncode(body);
      } catch (e) {
        bodyAsString = body.toString();
      }
      curlParts.add(" \\\n  -d '${bodyAsString.replaceAll("'", "'\\''")}'");
    }

    curlParts.add(' \\\n  "$url"');

    final curlCommand = curlParts.join('');

    // ignore: avoid_print
    print('┌───────────────── 🔥 cURL ─────────────────┐');
    // ignore: avoid_print
    print(curlCommand);
    // ignore: avoid_print
    print('└───────────────────────────────────────────┘');
  }
}
