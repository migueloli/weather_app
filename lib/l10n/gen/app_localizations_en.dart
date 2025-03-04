// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Weather App';

  @override
  String get noSavedCities => 'No saved cities';

  @override
  String get addCityToSeeWeather => 'Add a city to see weather information';

  @override
  String get searchForCities => 'Search for cities';

  @override
  String get searchForAnotherCity => 'Try searching for another city name';

  @override
  String get weatherSearchHint => 'Search for a city';

  @override
  String get citySearch => 'City Search';

  @override
  String get weatherDataUnavailable => 'Weather data unavailable';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get errorRetry => 'Please try again';

  @override
  String get errorNetwork => 'No internet connection available';

  @override
  String get errorServer => 'Server error. Please try again later';

  @override
  String get errorNotFound => 'No results found';

  @override
  String get errorAuthorization => 'Authorization error. Please login again.';

  @override
  String get errorDataFormat => 'Invalid data received. Please try again.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get errorClient => 'Request error. Please try again.';

  @override
  String get errorCancelled => 'Operation was cancelled.';

  @override
  String get errorLocationPermission => 'Location permission denied. Weather for your location is unavailable.';

  @override
  String get errorStorage => 'Storage error. Please check your device storage.';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionGoBack => 'Go Back';
}
