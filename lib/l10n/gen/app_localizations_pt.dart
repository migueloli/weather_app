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
  String get searchForAnotherCity => 'Tente pesquisar por outro nome de cidade';

  @override
  String get weatherSearchHint => 'Buscar por uma cidade';

  @override
  String get citySearch => 'Pesquisa de Cidade';

  @override
  String get weatherDataUnavailable => 'Dados meteorológicos indisponíveis';

  @override
  String get weatherTemperature => 'Temperatura';

  @override
  String get weatherHumidity => 'Umidade';

  @override
  String get weatherWindSpeed => 'Velocidade do Vento';

  @override
  String get weatherPressure => 'Pressão';

  @override
  String get weatherFeelsLike => 'Sensação Térmica';

  @override
  String get hourlyForecast => 'Previsão Horária';

  @override
  String get dailyForecast => 'Previsão de 7 Dias';

  @override
  String get today => 'Hoje';

  @override
  String get dayMon => 'Seg';

  @override
  String get dayTue => 'Ter';

  @override
  String get dayWed => 'Qua';

  @override
  String get dayThu => 'Qui';

  @override
  String get dayFri => 'Sex';

  @override
  String get daySat => 'Sáb';

  @override
  String get daySun => 'Dom';

  @override
  String get dayMonday => 'Segunda-feira';

  @override
  String get dayTuesday => 'Terça-feira';

  @override
  String get dayWednesday => 'Quarta-feira';

  @override
  String get dayThursday => 'Quinta-feira';

  @override
  String get dayFriday => 'Sexta-feira';

  @override
  String get daySaturday => 'Sábado';

  @override
  String get daySunday => 'Domingo';

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
  String get errorAuthorization => 'Erro de autorização. Por favor, faça login novamente.';

  @override
  String get errorDataFormat => 'Dados inválidos recebidos. Por favor, tente novamente.';

  @override
  String get errorUnknown => 'Ocorreu um erro inesperado. Por favor, tente novamente.';

  @override
  String get errorClient => 'Erro de requisição. Por favor, tente novamente.';

  @override
  String get errorCancelled => 'Operação foi cancelada.';

  @override
  String get errorLocationPermission => 'Permissão de localização negada. O clima para sua localização está indisponível.';

  @override
  String get errorStorage => 'Erro de armazenamento. Por favor, verifique o armazenamento do seu dispositivo.';

  @override
  String get actionRefresh => 'Atualizar';

  @override
  String get actionRetry => 'Tentar Novamente';

  @override
  String get actionGoBack => 'Voltar';
}
