import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/domain/repositories/weather_repository_interface.dart';

class GetWeatherUseCase {
  const GetWeatherUseCase(this._weatherRepository);

  final WeatherRepositoryInterface _weatherRepository;

  Future<Weather> call({
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
