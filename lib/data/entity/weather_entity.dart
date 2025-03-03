import 'dart:convert';

import 'package:objectbox/objectbox.dart';
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

  // Store the full JSON of the weather data
  final String weatherData;

  // When this data was fetched
  final int timestamp;

  Weather toWeather() {
    final json = jsonDecode(weatherData) as Map<String, dynamic>;
    return Weather.fromJson(json);
  }

  // Check if the data is stale (older than 1 hour)
  bool get isStale {
    final now = DateTime.now().millisecondsSinceEpoch;
    const hourInMillis = 60 * 60 * 1000;
    return (now - timestamp) > hourInMillis;
  }
}
