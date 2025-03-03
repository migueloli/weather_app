import 'package:weather_app/data/models/weather.dart';

abstract class WeatherLocalDataSource {
  const WeatherLocalDataSource();

  Weather? getWeather(double lat, double lon);
  Future<bool> saveWeather(Weather weather);
  int? getLastUpdatedTimestamp(double lat, double lon);
}
