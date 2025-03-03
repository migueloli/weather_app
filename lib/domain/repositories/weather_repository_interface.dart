import 'package:weather_app/data/models/weather.dart';

abstract class WeatherRepositoryInterface {
  const WeatherRepositoryInterface();

  Future<Weather> getWeather({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
    bool forceRefresh = false,
  });

  int? getLastUpdatedTimestamp(double lat, double lon);
}
