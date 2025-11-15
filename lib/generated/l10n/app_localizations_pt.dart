// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'TravelSpot';

  @override
  String get login => 'Entrar';

  @override
  String get register => 'Cadastrar';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get name => 'Nome';

  @override
  String get confirmPassword => 'Confirmar Senha';

  @override
  String get emailRequired => 'Por favor, insira seu e-mail';

  @override
  String get emailInvalid => 'Por favor, insira um e-mail válido';

  @override
  String get passwordRequired => 'Por favor, insira sua senha';

  @override
  String get passwordTooShort => 'A senha deve ter pelo menos 6 caracteres';

  @override
  String get nameRequired => 'Por favor, insira seu nome';

  @override
  String get confirmPasswordRequired => 'Por favor, confirme sua senha';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get dontHaveAccount => 'Não tem uma conta? Cadastre-se';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta? Entre';

  @override
  String get loginSuccess => 'Login realizado com sucesso!';

  @override
  String get registerSuccess => 'Cadastro realizado com sucesso!';

  @override
  String get loginFailed => 'Falha no login';

  @override
  String get registrationFailed => 'Falha no cadastro';

  @override
  String get loading => 'Carregando...';

  @override
  String get welcome => 'Bem-vindo ao TravelSpot!';

  @override
  String get createAccount => 'Crie sua conta';

  @override
  String get signInToAccount => 'Entre na sua conta';

  @override
  String get biometricTitle => 'Bem-vindo de volta!';

  @override
  String get biometricDescription => 'Use sua biometria para acessar rapidamente sua conta';

  @override
  String get useBiometric => 'Usar Biometria';

  @override
  String get useEmailPassword => 'Usar Email e Senha';

  @override
  String get biometricAlternative => 'Ou toque em \"Usar Email e Senha\" para fazer login normalmente';

  @override
  String get biometricAuthenticating => 'Verificando biometria...';

  @override
  String get biometricError => 'Erro na autenticação biométrica';

  @override
  String get goToLogin => 'Ir para Login';
}
