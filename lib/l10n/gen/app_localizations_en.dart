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
  String get weatherSearchHint => 'Search for a city';

  @override
  String get citySearch => 'City Search';

  @override
  String get weatherTitle => 'Weather';

  @override
  String get weatherDetails => 'Weather Details';

  @override
  String get weatherTemperature => 'Temperature';

  @override
  String get weatherHumidity => 'Humidity';

  @override
  String get weatherWindSpeed => 'Wind Speed';

  @override
  String get weatherPressure => 'Pressure';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get actionRetry => 'Retry';
}
