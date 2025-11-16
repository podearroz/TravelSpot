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

  @override
  String get logout => 'Logout';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get close => 'Close';

  @override
  String get send => 'Send';

  @override
  String get places => 'Places';

  @override
  String get addPlace => 'Add Place';

  @override
  String get placeAddedSuccess => 'Place added successfully!';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get placeName => 'Place Name';

  @override
  String get placeNameRequired => 'Name is required';

  @override
  String get description => 'Description';

  @override
  String get placeType => 'Place Type';

  @override
  String get address => 'Address';

  @override
  String get addressRequired => 'Address is required';

  @override
  String get coordinatesOptional => 'Coordinates (Optional)';

  @override
  String get latitude => 'Latitude';

  @override
  String get latitudeExample => 'Ex: -23.5505';

  @override
  String get longitude => 'Longitude';

  @override
  String get longitudeExample => 'Ex: -46.6333';

  @override
  String get selectOnMap => 'Select on Map';

  @override
  String get cuisineTypes => 'Cuisine Types:';

  @override
  String get selectImage => 'Select Image';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get cropImage => 'Crop Image';

  @override
  String uploadImageError(String error) {
    return 'Image upload error: $error';
  }

  @override
  String get coordinatesSelector => 'Coordinates Selector';

  @override
  String get mapFeatureComingSoon => 'Map feature will be implemented soon!';

  @override
  String get mapImplementationInfo => 'To implement:\n• Add google_maps_flutter to pubspec.yaml\n• Configure Google Maps API Keys\n• Create interactive selection widget';

  @override
  String get useExampleSP => 'Use Example (SP)';

  @override
  String get exampleCoordinatesSet => 'Example coordinates set (São Paulo)';

  @override
  String get errorLoadingPlaces => 'Error loading places';

  @override
  String get noPlacesFound => 'No places found';

  @override
  String get loadingPlaces => 'Loading places...';

  @override
  String errorFavoriting(String message) {
    return 'Error favoriting: $message';
  }

  @override
  String get needsAuthentication => 'You need to be logged in to favorite places';

  @override
  String get favorites => 'Favorites';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get errorLoadingFavorites => 'Error loading favorites';

  @override
  String get noFavoritesFound => 'No favorites found';

  @override
  String get loadingFavorites => 'Loading favorites...';

  @override
  String get reviews => 'Reviews';

  @override
  String reviewsOf(String placeName) {
    return 'Reviews of $placeName';
  }

  @override
  String get addReview => 'Add Review';

  @override
  String get rating => 'Rating';

  @override
  String get comment => 'Comment';

  @override
  String get commentOptional => 'Comment (optional)';

  @override
  String get errorLoadingReviews => 'Error loading reviews';

  @override
  String get noReviewsFound => 'No reviews found';

  @override
  String get tryAgain => 'Try again';

  @override
  String get reviewLabel => 'Reviews';

  @override
  String get viewDetails => 'View details';

  @override
  String get orContinueWithEmail => 'Or continue with email and password';

  @override
  String get signInWithBiometric => 'Sign in with biometric';

  @override
  String get signInWithPin => 'Sign in with PIN';

  @override
  String get noFavoritesYet => 'No favorites yet';

  @override
  String get addPlacesToFavorites => 'Add places to your favorites to see them here';

  @override
  String get ratePlace => 'Rate';

  @override
  String get noReviewsYet => 'No reviews yet. Be the first to review!';

  @override
  String get by => 'By:';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get ratingLabel => 'Rating';

  @override
  String imageProcessingError(String error) {
    return 'Error processing image: $error';
  }

  @override
  String get needsAuthToFavorite => 'You need to be logged in to favorite.';

  @override
  String get needsAuthToRemoveFavorite => 'You need to be logged in to remove favorites';

  @override
  String get needsAuthToReview => 'You need to be logged in to review.';

  @override
  String reviewPlace(String placeName) {
    return 'Review $placeName';
  }

  @override
  String get yourRating => 'Your rating:';

  @override
  String get commentOptionalLabel => 'Comment (optional):';

  @override
  String get shareExperience => 'Share your experience...';

  @override
  String get ratingVeryBad => 'Very bad';

  @override
  String get ratingBad => 'Bad';

  @override
  String get ratingRegular => 'Regular';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingExcellent => 'Excellent';

  @override
  String reviewsError(String message) {
    return 'Error: $message';
  }

  @override
  String reviewBy(String author) {
    return 'By: $author';
  }

  @override
  String get details => 'Details';

  @override
  String get placeNotFound => 'Place not found';

  @override
  String get sessionExpired => 'Session Expired';

  @override
  String get sessionExpiredDescription => 'Your session has expired or your credentials are no longer valid.';

  @override
  String get pleaseLoginAgain => 'Please log in again to continue.';

  @override
  String get loginButton => 'Login';
}
