import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'TravelSpot'**
  String get appTitle;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// Invalid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// Password validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// Password too short validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameRequired;

  /// Confirm password validation message
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// Passwords do not match validation message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Link to register page
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get dontHaveAccount;

  /// Link to login page
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// Registration success message
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registerSuccess;

  /// Login failed message
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// Registration failed message
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome to TravelSpot!'**
  String get welcome;

  /// Create account subtitle
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccount;

  /// Sign in subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToAccount;

  /// Biometric authentication title
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get biometricTitle;

  /// Biometric authentication description
  ///
  /// In en, this message translates to:
  /// **'Use your biometric to quickly access your account'**
  String get biometricDescription;

  /// Use biometric button
  ///
  /// In en, this message translates to:
  /// **'Use Biometric'**
  String get useBiometric;

  /// Use email and password button
  ///
  /// In en, this message translates to:
  /// **'Use Email and Password'**
  String get useEmailPassword;

  /// Biometric alternative text
  ///
  /// In en, this message translates to:
  /// **'Or tap \"Use Email and Password\" to login normally'**
  String get biometricAlternative;

  /// Biometric authentication in progress
  ///
  /// In en, this message translates to:
  /// **'Checking biometrics...'**
  String get biometricAuthenticating;

  /// Biometric authentication error
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication error'**
  String get biometricError;

  /// Go to login button
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @places.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get places;

  /// No description provided for @addPlace.
  ///
  /// In en, this message translates to:
  /// **'Add Place'**
  String get addPlace;

  /// No description provided for @placeAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Place added successfully!'**
  String get placeAddedSuccess;

  /// Error message prefix
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorPrefix(String message);

  /// No description provided for @placeName.
  ///
  /// In en, this message translates to:
  /// **'Place Name'**
  String get placeName;

  /// No description provided for @placeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get placeNameRequired;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @placeType.
  ///
  /// In en, this message translates to:
  /// **'Place Type'**
  String get placeType;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressRequired;

  /// No description provided for @coordinatesOptional.
  ///
  /// In en, this message translates to:
  /// **'Coordinates (Optional)'**
  String get coordinatesOptional;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @latitudeExample.
  ///
  /// In en, this message translates to:
  /// **'Ex: -23.5505'**
  String get latitudeExample;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @longitudeExample.
  ///
  /// In en, this message translates to:
  /// **'Ex: -46.6333'**
  String get longitudeExample;

  /// No description provided for @selectOnMap.
  ///
  /// In en, this message translates to:
  /// **'Select on Map'**
  String get selectOnMap;

  /// No description provided for @cuisineTypes.
  ///
  /// In en, this message translates to:
  /// **'Cuisine Types:'**
  String get cuisineTypes;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImage;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @cropImage.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get cropImage;

  /// No description provided for @uploadImageError.
  ///
  /// In en, this message translates to:
  /// **'Image upload error: {error}'**
  String uploadImageError(String error);

  /// No description provided for @coordinatesSelector.
  ///
  /// In en, this message translates to:
  /// **'Coordinates Selector'**
  String get coordinatesSelector;

  /// No description provided for @mapFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Map feature will be implemented soon!'**
  String get mapFeatureComingSoon;

  /// No description provided for @mapImplementationInfo.
  ///
  /// In en, this message translates to:
  /// **'To implement:\n• Add google_maps_flutter to pubspec.yaml\n• Configure Google Maps API Keys\n• Create interactive selection widget'**
  String get mapImplementationInfo;

  /// No description provided for @useExampleSP.
  ///
  /// In en, this message translates to:
  /// **'Use Example (SP)'**
  String get useExampleSP;

  /// No description provided for @exampleCoordinatesSet.
  ///
  /// In en, this message translates to:
  /// **'Example coordinates set (São Paulo)'**
  String get exampleCoordinatesSet;

  /// No description provided for @errorLoadingPlaces.
  ///
  /// In en, this message translates to:
  /// **'Error loading places'**
  String get errorLoadingPlaces;

  /// No description provided for @noPlacesFound.
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get noPlacesFound;

  /// No description provided for @loadingPlaces.
  ///
  /// In en, this message translates to:
  /// **'Loading places...'**
  String get loadingPlaces;

  /// No description provided for @errorFavoriting.
  ///
  /// In en, this message translates to:
  /// **'Error favoriting: {message}'**
  String errorFavoriting(String message);

  /// No description provided for @needsAuthentication.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to favorite places'**
  String get needsAuthentication;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @errorLoadingFavorites.
  ///
  /// In en, this message translates to:
  /// **'Error loading favorites'**
  String get errorLoadingFavorites;

  /// No description provided for @noFavoritesFound.
  ///
  /// In en, this message translates to:
  /// **'No favorites found'**
  String get noFavoritesFound;

  /// No description provided for @loadingFavorites.
  ///
  /// In en, this message translates to:
  /// **'Loading favorites...'**
  String get loadingFavorites;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @reviewsOf.
  ///
  /// In en, this message translates to:
  /// **'Reviews of {placeName}'**
  String reviewsOf(String placeName);

  /// No description provided for @addReview.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get addReview;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @commentOptional.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get commentOptional;

  /// No description provided for @errorLoadingReviews.
  ///
  /// In en, this message translates to:
  /// **'Error loading reviews'**
  String get errorLoadingReviews;

  /// No description provided for @noReviewsFound.
  ///
  /// In en, this message translates to:
  /// **'No reviews found'**
  String get noReviewsFound;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @reviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewLabel;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @orContinueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Or continue with email and password'**
  String get orContinueWithEmail;

  /// No description provided for @signInWithBiometric.
  ///
  /// In en, this message translates to:
  /// **'Sign in with biometric'**
  String get signInWithBiometric;

  /// No description provided for @signInWithPin.
  ///
  /// In en, this message translates to:
  /// **'Sign in with PIN'**
  String get signInWithPin;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @addPlacesToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add places to your favorites to see them here'**
  String get addPlacesToFavorites;

  /// No description provided for @ratePlace.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get ratePlace;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet. Be the first to review!'**
  String get noReviewsYet;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'By:'**
  String get by;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get ratingLabel;

  /// Image processing error message
  ///
  /// In en, this message translates to:
  /// **'Error processing image: {error}'**
  String imageProcessingError(String error);

  /// No description provided for @needsAuthToFavorite.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to favorite.'**
  String get needsAuthToFavorite;

  /// No description provided for @needsAuthToRemoveFavorite.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to remove favorites'**
  String get needsAuthToRemoveFavorite;

  /// No description provided for @needsAuthToReview.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to review.'**
  String get needsAuthToReview;

  /// Review place title
  ///
  /// In en, this message translates to:
  /// **'Review {placeName}'**
  String reviewPlace(String placeName);

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your rating:'**
  String get yourRating;

  /// No description provided for @commentOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional):'**
  String get commentOptionalLabel;

  /// No description provided for @shareExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience...'**
  String get shareExperience;

  /// No description provided for @ratingVeryBad.
  ///
  /// In en, this message translates to:
  /// **'Very bad'**
  String get ratingVeryBad;

  /// No description provided for @ratingBad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get ratingBad;

  /// No description provided for @ratingRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get ratingRegular;

  /// No description provided for @ratingGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get ratingGood;

  /// No description provided for @ratingExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get ratingExcellent;

  /// Reviews error message
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String reviewsError(String message);

  /// Review author
  ///
  /// In en, this message translates to:
  /// **'By: {author}'**
  String reviewBy(String author);

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @placeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Place not found'**
  String get placeNotFound;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get sessionExpired;

  /// No description provided for @sessionExpiredDescription.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired or your credentials are no longer valid.'**
  String get sessionExpiredDescription;

  /// No description provided for @pleaseLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'Please log in again to continue.'**
  String get pleaseLoginAgain;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
