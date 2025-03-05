import 'dart:async';

import 'package:weather_app/data/models/weather.dart';

abstract class WeatherLocalDataSource {
  const WeatherLocalDataSource();

  FutureOr<Weather?> getWeather(double lat, double lon);
  FutureOr<bool> saveWeather(Weather weather);
  FutureOr<int?> getLastUpdatedTimestamp(double lat, double lon);
}
