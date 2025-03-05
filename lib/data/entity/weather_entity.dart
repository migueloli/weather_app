import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:weather_app/core/utils/json_types.dart';
import 'package:weather_app/data/models/weather.dart';

@Entity()
class WeatherEntity {
  WeatherEntity({
    required this.lat,
    required this.lon,
    required this.weatherData,
    required this.timestamp,
    this.id = 0,
    String? coordinates,
  }) : coordinates = coordinates ?? '[$lat, $lon]';

  factory WeatherEntity.fromWeather(Weather weather) {
    return WeatherEntity(
      lat: weather.coord.lat,
      lon: weather.coord.lon,
      weatherData: jsonEncode(weather.toJson()),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @Id()
  int id = 0;

  final String coordinates;
  final double lat;
  final double lon;
  final String weatherData;
  final int timestamp;

  Weather toWeather() {
    final json = jsonDecode(weatherData) as JsonObject;
    return Weather.fromJson(json);
  }

  bool get isStale {
    final now = DateTime.now().millisecondsSinceEpoch;
    const hourInMillis = 60 * 60 * 1000;
    return (now - timestamp) > hourInMillis;
  }
}
