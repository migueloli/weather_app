import 'package:weather_app/core/utils/json_types.dart';

class WeatherCoordinates {
  const WeatherCoordinates({required this.lon, required this.lat});

  factory WeatherCoordinates.fromJson(JsonObject json) {
    return WeatherCoordinates(
      lon: json['lon'].toDouble(),
      lat: json['lat'].toDouble(),
    );
  }
  final double lon;
  final double lat;

  JsonObject toJson() {
    return {'lon': lon, 'lat': lat};
  }

  @override
  String toString() {
    return '[$lon, $lat]';
  }
}
