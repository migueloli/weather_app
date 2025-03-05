import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/forecast.dart';
import 'package:weather_app/data/models/weather.dart';

abstract class WeatherRepositoryInterface {
  const WeatherRepositoryInterface();

  Future<Result<Weather, AppException>> getWeather({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
    bool forceRefresh = false,
  });

  Future<Result<Forecast, AppException>> getForecast({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
  });

  Result<int?, AppException> getLastUpdatedTimestamp(double lat, double lon);
}
