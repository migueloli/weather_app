import 'package:weather_app/core/utils/json_types.dart';

class WeatherWind {
  const WeatherWind({required this.speed, required this.deg, this.gust});

  factory WeatherWind.fromJson(JsonObject json) {
    return WeatherWind(
      speed: json['speed'].toDouble(),
      deg: json['deg'],
      gust: json['gust']?.toDouble(),
    );
  }
  final double speed;
  final int deg;
  final double? gust;

  JsonObject toJson() {
    return {'speed': speed, 'deg': deg, 'gust': gust};
  }
}
