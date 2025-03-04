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
  String get searchForAnotherCity => 'Versuchen Sie, nach einem anderen Stadtnamen zu suchen';

  @override
  String get weatherSearchHint => 'Nach einer Stadt suchen';

  @override
  String get citySearch => 'Stadtsuche';

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
  String get errorAuthorization => 'Autorisierungsfehler. Bitte melden Sie sich erneut an.';

  @override
  String get errorDataFormat => 'Ungültige Daten empfangen. Bitte versuchen Sie es erneut.';

  @override
  String get errorUnknown => 'Ein unerwarteter Fehler ist aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get errorClient => 'Anforderungsfehler. Bitte versuchen Sie es erneut.';

  @override
  String get errorCancelled => 'Der Vorgang wurde abgebrochen.';

  @override
  String get errorLocationPermission => 'Standortberechtigung verweigert. Wetter für Ihren Standort ist nicht verfügbar.';

  @override
  String get errorStorage => 'Speicherfehler. Bitte überprüfen Sie den Speicher Ihres Geräts.';

  @override
  String get actionRefresh => 'Aktualisieren';

  @override
  String get actionRetry => 'Wiederholen';

  @override
  String get actionGoBack => 'Zurück';
}
