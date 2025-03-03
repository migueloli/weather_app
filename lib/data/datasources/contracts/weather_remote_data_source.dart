import 'package:weather_app/data/models/weather.dart';

abstract class WeatherRemoteDataSource {
  Future<Weather> getWeather({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
  });
}
