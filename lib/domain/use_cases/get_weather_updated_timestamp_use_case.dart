import 'package:weather_app/domain/repositories/weather_repository_interface.dart';

class GetWeatherUpdatedTimestampUseCase {
  const GetWeatherUpdatedTimestampUseCase(this._weatherRepository);

  final WeatherRepositoryInterface _weatherRepository;

  int? call(double lat, double lon) {
    return _weatherRepository.getLastUpdatedTimestamp(lat, lon);
  }
}
