import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  static const String _biometricEnabledKey = 'biometric_auth_enabled';

  /// Verifica se o dispositivo suporta autenticação biométrica
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      print('Error checking device support: $e');
      return false;
    }
  }

  /// Verifica se há biometrias cadastradas no dispositivo
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      print('Error checking biometrics availability: $e');
      return false;
    }
  }

  /// Retorna a lista de biometrias disponíveis
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Realiza a autenticação biométrica
  Future<bool> authenticate({
    required String localizedReason,
    bool biometricOnly = false,
  }) async {
    try {
      final bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: true,
        ),
      );
      return isAuthenticated;
    } on PlatformException catch (e) {
      print('Biometric authentication PlatformException: ${e.code} - ${e.message}');
      
      // Tratar erros específicos
      switch (e.code) {
        case 'no_fragment_activity':
          print('FragmentActivity error - this should be fixed by MainActivity changes');
          return false;
        case 'NotAvailable':
          print('Biometric authentication not available');
          return false;
        case 'NotEnrolled':
          print('No biometrics enrolled');
          return false;
        case 'UserCancel':
        case 'UserFallback':
          print('User cancelled authentication');
          return false;
        default:
          print('Unknown biometric error: ${e.code}');
          return false;
      }
    } catch (e) {
      print('General biometric authentication error: $e');
      return false;
    }
  }

  /// Verifica se a autenticação biométrica está habilitada nas configurações do app
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? true; // Default: true
  }

  /// Define se a autenticação biométrica está habilitada
  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
  }

  /// Verifica se pode usar biometria (dispositivo suporta + há biometrias cadastradas)
  Future<bool> canUseBiometricAuth() async {
    try {
      final isSupported = await isDeviceSupported();
      final canCheck = await canCheckBiometrics();
      final hasBiometrics = (await getAvailableBiometrics()).isNotEmpty;

      print('Biometric check: supported=$isSupported, canCheck=$canCheck, hasBiometrics=$hasBiometrics');
      return isSupported && canCheck && hasBiometrics;
    } catch (e) {
      print('Error in canUseBiometricAuth: $e');
      return false;
    }
  }

  /// Solicita autenticação biométrica para login
  Future<bool> authenticateForLogin() async {
    try {
      print('Checking if biometric authentication is available...');
      
      // Verificação simples se pode usar biometria
      final canUse = await canUseBiometricAuth();
      if (!canUse) {
        print('Biometric authentication not available on this device');
        return false;
      }

      print('Requesting biometric authentication...');
      
      // Tentar autenticação (o sistema vai mostrar o prompt nativo)
      final result = await authenticate(
        localizedReason: 'Use sua digital, face ou PIN para acessar',
        biometricOnly: false, // Permitir PIN/senha como fallback
      );
      
      print('Biometric authentication completed with result: $result');
      return result;
    } catch (e) {
      print('Error in authenticateForLogin: $e');
      return false;
    }
  }
}
