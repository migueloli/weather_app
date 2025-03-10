import 'package:weather_app/core/utils/json_types.dart';

class WeatherSys {
  const WeatherSys({
    required this.country,
    required this.sunrise,
    required this.sunset,
    this.type,
    this.id,
  });

  factory WeatherSys.fromJson(JsonObject json) {
    return WeatherSys(
      type: json['type'],
      id: json['id'],
      country: json['country'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
  final int? type;
  final int? id;
  final String country;
  final int sunrise;
  final int sunset;

  JsonObject toJson() {
    return {
      'type': type,
      'id': id,
      'country': country,
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }
}
