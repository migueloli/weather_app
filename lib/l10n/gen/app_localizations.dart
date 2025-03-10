import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
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
/// import 'gen/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('de'),
    Locale('en'),
    Locale('pt')
  ];

  /// Default title of the app
  ///
  /// In en, this message translates to:
  /// **'Weather App'**
  String get appTitle;

  /// Title for empty state when no cities are saved
  ///
  /// In en, this message translates to:
  /// **'No saved cities'**
  String get noSavedCities;

  /// Subtitle for empty state suggesting to add cities
  ///
  /// In en, this message translates to:
  /// **'Add a city to see weather information'**
  String get addCityToSeeWeather;

  /// Label for button to search for cities
  ///
  /// In en, this message translates to:
  /// **'Search for cities'**
  String get searchForCities;

  /// Suggestion text shown when city search returns no results
  ///
  /// In en, this message translates to:
  /// **'Try searching for another city name'**
  String get searchForAnotherCity;

  /// Hint text for city search field
  ///
  /// In en, this message translates to:
  /// **'Search for a city'**
  String get weatherSearchHint;

  /// Label for city search
  ///
  /// In en, this message translates to:
  /// **'City Search'**
  String get citySearch;

  /// Message shown when weather data cannot be displayed
  ///
  /// In en, this message translates to:
  /// **'Weather data unavailable'**
  String get weatherDataUnavailable;

  /// Label for temperature measurement
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get weatherTemperature;

  /// Label for humidity measurement
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get weatherHumidity;

  /// Label for wind speed measurement
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get weatherWindSpeed;

  /// Label for atmospheric pressure measurement
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get weatherPressure;

  /// Label for perceived temperature measurement
  ///
  /// In en, this message translates to:
  /// **'Feels Like'**
  String get weatherFeelsLike;

  /// Label for minimum temperature
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get weatherMin;

  /// Label for maximum temperature
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get weatherMax;

  /// Label for hourly weather forecast section
  ///
  /// In en, this message translates to:
  /// **'Hourly Forecast'**
  String get hourlyForecast;

  /// Label for daily weather forecast section
  ///
  /// In en, this message translates to:
  /// **'Daily Forecast'**
  String get dailyForecast;

  /// Label for today in daily forecast
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Title for the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for language settings
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label for unit system settings
  ///
  /// In en, this message translates to:
  /// **'Unit System'**
  String get unitSystem;

  /// Label for metric unit system
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// Label for imperial unit system
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get imperial;

  /// Label for temperature
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// Label for speed
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// Label for theme mode settings
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// Label for system theme mode option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Label for light theme mode option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Label for dark theme mode option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Monday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// Tuesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// Wednesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// Thursday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// Friday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// Saturday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// Sunday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySun;

  /// Full name of Monday
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get dayMonday;

  /// Full name of Tuesday
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get dayTuesday;

  /// Full name of Wednesday
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get dayWednesday;

  /// Full name of Thursday
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get dayThursday;

  /// Full name of Friday
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get dayFriday;

  /// Full name of Saturday
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get daySaturday;

  /// Full name of Sunday
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get daySunday;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// Message suggesting to retry after an error
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get errorRetry;

  /// Error message when network is unavailable
  ///
  /// In en, this message translates to:
  /// **'No internet connection available'**
  String get errorNetwork;

  /// Error message when server returns an error
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later'**
  String get errorServer;

  /// Message shown when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get errorNotFound;

  /// Error message shown for authorization issues
  ///
  /// In en, this message translates to:
  /// **'Authorization error. Please login again.'**
  String get errorAuthorization;

  /// Error message shown when received data is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid data received. Please try again.'**
  String get errorDataFormat;

  /// Generic error message for unknown errors
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnknown;

  /// Error message shown for client-side errors
  ///
  /// In en, this message translates to:
  /// **'Request error. Please try again.'**
  String get errorClient;

  /// Error message shown when operation is cancelled
  ///
  /// In en, this message translates to:
  /// **'Operation was cancelled.'**
  String get errorCancelled;

  /// Error message shown when location permission is denied
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Weather for your location is unavailable.'**
  String get errorLocationPermission;

  /// Error message shown for storage-related errors
  ///
  /// In en, this message translates to:
  /// **'Storage error. Please check your device storage.'**
  String get errorStorage;

  /// Label for refresh action
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get actionRefresh;

  /// Label for retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// Label for go back action
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get actionGoBack;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
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
