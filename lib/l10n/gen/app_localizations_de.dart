// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Wetter-App';

  @override
  String get noSavedCities => 'Keine gespeicherten Städte';

  @override
  String get addCityToSeeWeather => 'Fügen Sie eine Stadt hinzu, um Wetterinformationen zu sehen';

  @override
  String get searchForCities => 'Städte suchen';

  @override
  String get errorGeneric => 'Etwas ist schiefgelaufen';

  @override
  String get errorRetry => 'Bitte versuchen Sie es erneut';

  @override
  String get errorNetwork => 'Keine Internetverbindung verfügbar';

  @override
  String get errorServer => 'Serverfehler. Bitte versuchen Sie es später erneut';

  @override
  String get errorNotFound => 'Keine Ergebnisse gefunden';

  @override
  String get weatherSearchHint => 'Nach einer Stadt suchen';

  @override
  String get citySearch => 'Stadtsuche';

  @override
  String get weatherTitle => 'Wetter';

  @override
  String get weatherDetails => 'Wetterdetails';

  @override
  String get weatherTemperature => 'Temperatur';

  @override
  String get weatherHumidity => 'Luftfeuchtigkeit';

  @override
  String get weatherWindSpeed => 'Windgeschwindigkeit';

  @override
  String get weatherPressure => 'Luftdruck';

  @override
  String get actionRefresh => 'Aktualisieren';

  @override
  String get actionRetry => 'Wiederholen';
}
