import 'package:weather_app/core/utils/json_types.dart';

class WeatherRain {
  const WeatherRain({this.oneHour, this.threeHours});

  factory WeatherRain.fromJson(JsonObject json) {
    return WeatherRain(
      oneHour: json['1h']?.toDouble(),
      threeHours: json['3h']?.toDouble(),
    );
  }
  final double? oneHour;
  final double? threeHours;

  JsonObject toJson() {
    return {'1h': oneHour, '3h': threeHours};
  }
}
