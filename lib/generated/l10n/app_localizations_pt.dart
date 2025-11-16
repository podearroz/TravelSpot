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

  @override
  String get logout => 'Sair';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get error => 'Erro';

  @override
  String get success => 'Sucesso';

  @override
  String get close => 'Fechar';

  @override
  String get send => 'Enviar';

  @override
  String get places => 'Lugares';

  @override
  String get addPlace => 'Adicionar Local';

  @override
  String get placeAddedSuccess => 'Local adicionado com sucesso!';

  @override
  String errorPrefix(String message) {
    return 'Erro: $message';
  }

  @override
  String get placeName => 'Nome do Local';

  @override
  String get placeNameRequired => 'Nome é obrigatório';

  @override
  String get description => 'Descrição';

  @override
  String get placeType => 'Tipo de Local';

  @override
  String get address => 'Endereço';

  @override
  String get addressRequired => 'Endereço é obrigatório';

  @override
  String get coordinatesOptional => 'Coordenadas (Opcional)';

  @override
  String get latitude => 'Latitude';

  @override
  String get latitudeExample => 'Ex: -23.5505';

  @override
  String get longitude => 'Longitude';

  @override
  String get longitudeExample => 'Ex: -46.6333';

  @override
  String get selectOnMap => 'Selecionar no Mapa';

  @override
  String get cuisineTypes => 'Tipos de Culinária:';

  @override
  String get selectImage => 'Selecionar Imagem';

  @override
  String get gallery => 'Galeria';

  @override
  String get camera => 'Câmera';

  @override
  String get cropImage => 'Recortar Imagem';

  @override
  String uploadImageError(String error) {
    return 'Erro no upload da imagem: $error';
  }

  @override
  String get coordinatesSelector => 'Seletor de Coordenadas';

  @override
  String get mapFeatureComingSoon => 'Funcionalidade de mapa será implementada em breve!';

  @override
  String get mapImplementationInfo => 'Para implementar:\n• Adicionar google_maps_flutter ao pubspec.yaml\n• Configurar API Keys do Google Maps\n• Criar widget de seleção interativa';

  @override
  String get useExampleSP => 'Usar Exemplo (SP)';

  @override
  String get exampleCoordinatesSet => 'Coordenadas de exemplo definidas (São Paulo)';

  @override
  String get errorLoadingPlaces => 'Erro ao carregar os lugares';

  @override
  String get noPlacesFound => 'Nenhum lugar encontrado';

  @override
  String get loadingPlaces => 'Carregando lugares...';

  @override
  String errorFavoriting(String message) {
    return 'Erro ao favoritar: $message';
  }

  @override
  String get needsAuthentication => 'Você precisa estar logado para favoritar lugares';

  @override
  String get favorites => 'Favoritos';

  @override
  String get myFavorites => 'Meus Favoritos';

  @override
  String get errorLoadingFavorites => 'Erro ao carregar favoritos';

  @override
  String get noFavoritesFound => 'Nenhum favorito encontrado';

  @override
  String get loadingFavorites => 'Carregando favoritos...';

  @override
  String get reviews => 'Avaliações';

  @override
  String reviewsOf(String placeName) {
    return 'Avaliações de $placeName';
  }

  @override
  String get addReview => 'Adicionar Avaliação';

  @override
  String get rating => 'Nota';

  @override
  String get comment => 'Comentário';

  @override
  String get commentOptional => 'Comentário (opcional)';

  @override
  String get errorLoadingReviews => 'Erro ao carregar avaliações';

  @override
  String get noReviewsFound => 'Nenhuma avaliação encontrada';

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String get reviewLabel => 'Avaliações';

  @override
  String get viewDetails => 'Ver detalhes';

  @override
  String get orContinueWithEmail => 'Ou continue com email e senha';

  @override
  String get signInWithBiometric => 'Entrar com biometria';

  @override
  String get signInWithPin => 'Entrar com PIN';

  @override
  String get noFavoritesYet => 'Nenhum favorito ainda';

  @override
  String get addPlacesToFavorites => 'Adicione lugares aos seus favoritos para vê-los aqui';

  @override
  String get ratePlace => 'Avaliar';

  @override
  String get noReviewsYet => 'Nenhuma avaliação ainda. Seja o primeiro a avaliar!';

  @override
  String get by => 'Por:';

  @override
  String get submitReview => 'Enviar Avaliação';

  @override
  String get ratingLabel => 'Nota';

  @override
  String imageProcessingError(String error) {
    return 'Erro ao processar imagem: $error';
  }

  @override
  String get needsAuthToFavorite => 'Você precisa estar logado para favoritar.';

  @override
  String get needsAuthToRemoveFavorite => 'Você precisa estar logado para remover favoritos';

  @override
  String get needsAuthToReview => 'Você precisa estar logado para avaliar.';

  @override
  String reviewPlace(String placeName) {
    return 'Avaliar $placeName';
  }

  @override
  String get yourRating => 'Sua avaliação:';

  @override
  String get commentOptionalLabel => 'Comentário (opcional):';

  @override
  String get shareExperience => 'Compartilhe sua experiência...';

  @override
  String get ratingVeryBad => 'Muito ruim';

  @override
  String get ratingBad => 'Ruim';

  @override
  String get ratingRegular => 'Regular';

  @override
  String get ratingGood => 'Bom';

  @override
  String get ratingExcellent => 'Excelente';

  @override
  String reviewsError(String message) {
    return 'Erro: $message';
  }

  @override
  String reviewBy(String author) {
    return 'Por: $author';
  }

  @override
  String get details => 'Detalhes';

  @override
  String get placeNotFound => 'Local não encontrado';

  @override
  String get sessionExpired => 'Sessão Expirada';

  @override
  String get sessionExpiredDescription => 'Sua sessão expirou ou suas credenciais não são mais válidas.';

  @override
  String get pleaseLoginAgain => 'Por favor, faça login novamente para continuar.';

  @override
  String get loginButton => 'Fazer Login';
}
