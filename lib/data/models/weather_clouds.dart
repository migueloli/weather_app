import 'package:weather_app/core/utils/json_types.dart';

class WeatherClouds {
  const WeatherClouds({required this.all});

  factory WeatherClouds.fromJson(JsonObject json) {
    return WeatherClouds(all: json['all']);
  }
  final int all;

  JsonObject toJson() {
    return {'all': all};
  }
}
