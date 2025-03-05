import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/domain/repositories/weather_repository_interface.dart';

class GetWeatherUpdatedTimestampUseCase {
  const GetWeatherUpdatedTimestampUseCase(this._weatherRepository);

  final WeatherRepositoryInterface _weatherRepository;

  Future<Result<int?, AppException>> call(double lat, double lon) {
    return _weatherRepository.getLastUpdatedTimestamp(lat, lon);
  }
}
