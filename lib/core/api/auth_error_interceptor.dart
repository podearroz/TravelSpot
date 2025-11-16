import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';

/// Interceptor que detecta erros de autenticação (401, 403)
/// e redireciona para tela de sessão expirada
class AuthErrorInterceptor implements Interceptor {
  final GlobalKey<NavigatorState> navigatorKey;

  AuthErrorInterceptor(this.navigatorKey);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final response = await chain.proceed(chain.request);

    // Verificar se é erro de autenticação
    if (response.statusCode == 401 || response.statusCode == 403) {
      print('[AuthErrorInterceptor] Erro de autenticação detectado: ${response.statusCode}');
      
      // Navegar para tela de sessão expirada
      _navigateToSessionExpired();
    }

    return response;
  }

  void _navigateToSessionExpired() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      // Remover todas as rotas e ir para sessão expirada
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/session-expired',
        (route) => false,
      );
    }
  }
}
