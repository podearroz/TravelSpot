// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TravelSpot';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get nameRequired => 'Please enter your name';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get registerSuccess => 'Registration successful!';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get loading => 'Loading...';

  @override
  String get welcome => 'Welcome to TravelSpot!';

  @override
  String get createAccount => 'Create your account';

  @override
  String get signInToAccount => 'Sign in to your account';

  @override
  String get biometricTitle => 'Welcome back!';

  @override
  String get biometricDescription => 'Use your biometric to quickly access your account';

  @override
  String get useBiometric => 'Use Biometric';

  @override
  String get useEmailPassword => 'Use Email and Password';

  @override
  String get biometricAlternative => 'Or tap \"Use Email and Password\" to login normally';

  @override
  String get biometricAuthenticating => 'Checking biometrics...';

  @override
  String get biometricError => 'Biometric authentication error';

  @override
  String get goToLogin => 'Go to Login';
}
