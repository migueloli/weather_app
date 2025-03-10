import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';

class GetWeatherUseCase {
  const GetWeatherUseCase({required WeatherRepository weatherRepository})
    : _weatherRepository = weatherRepository;

  final WeatherRepository _weatherRepository;

  Future<Result<Weather, AppException>> call({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
    bool forceRefresh = false,
  }) {
    return _weatherRepository.getWeather(
      lat: lat,
      lon: lon,
      units: units,
      lang: lang,
      forceRefresh: forceRefresh,
    );
  }
}
