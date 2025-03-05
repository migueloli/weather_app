import 'package:weather_app/data/models/forecast.dart';
import 'package:weather_app/data/models/weather.dart';

abstract class WeatherRemoteDataSource {
  const WeatherRemoteDataSource();

  Future<Weather> getWeather({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
  });

  Future<Forecast> getForecast({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
    int cnt = 40,
  });
}
