// Exceções para o sistema de autenticação
class TravelSpotAuthException implements Exception {
  final String message;
  final String? code;

  TravelSpotAuthException(this.message, {this.code});

  @override
  String toString() => 'TravelSpotAuthException: $message (code: $code)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class ServerException implements Exception {
  final String message;

  ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}