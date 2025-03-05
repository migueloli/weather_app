import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/forecast.dart';
import 'package:weather_app/domain/repositories/weather_repository_interface.dart';

class GetForecastUseCase {
  const GetForecastUseCase({
    required WeatherRepositoryInterface weatherRepository,
  }) : _weatherRepository = weatherRepository;

  final WeatherRepositoryInterface _weatherRepository;

  Future<Result<Forecast, AppException>> call({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
  }) async {
    return _weatherRepository.getForecast(
      lat: lat,
      lon: lon,
      units: units,
      lang: lang,
    );
  }
}
