import 'package:weather_app/core/config/env_config.dart';
import 'package:weather_app/core/utils/json_types.dart';

class WeatherCondition {
  const WeatherCondition({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherCondition.fromJson(JsonObject json) {
    return WeatherCondition(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
  final int id;
  final String main;
  final String description;
  final String icon;

  JsonObject toJson() {
    return {'id': id, 'main': main, 'description': description, 'icon': icon};
  }

  String get iconUrl => '${EnvConfig.weatherApiBaseUrl}/img/wn/$icon@2x.png';
}
