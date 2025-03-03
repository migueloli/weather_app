// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Weather App';

  @override
  String get noSavedCities => 'Sem cidades salvas';

  @override
  String get addCityToSeeWeather => 'Adicione uma cidade para ver informações meteorológicas';

  @override
  String get searchForCities => 'Buscar cidades';

  @override
  String get weatherSearchHint => 'Buscar por uma cidade';

  @override
  String get citySearch => 'Pesquisa de Cidade';

  @override
  String get weatherTitle => 'Clima';

  @override
  String get weatherDetails => 'Detalhes do Clima';

  @override
  String get weatherTemperature => 'Temperatura';

  @override
  String get weatherHumidity => 'Umidade';

  @override
  String get weatherWindSpeed => 'Velocidade do Vento';

  @override
  String get weatherPressure => 'Pressão';

  @override
  String get errorGeneric => 'Algo deu errado';

  @override
  String get errorRetry => 'Por favor, tente novamente';

  @override
  String get errorNetwork => 'Sem conexão com a internet';

  @override
  String get errorServer => 'Erro no servidor. Por favor, tente mais tarde';

  @override
  String get errorNotFound => 'Nenhum resultado encontrado';

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
  String get actionRefresh => 'Atualizar';

  @override
  String get actionRetry => 'Tentar Novamente';

  @override
  String get actionGoBack => 'Go Back';
}
