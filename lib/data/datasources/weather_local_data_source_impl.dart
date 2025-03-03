import 'package:weather_app/data/datasources/contracts/weather_local_data_source.dart';
import 'package:weather_app/data/entity/weather_entity.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/objectbox.g.dart';

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  WeatherLocalDataSourceImpl({required Store store}) {
    _weatherBox = Box<WeatherEntity>(store);
  }

  late final Box<WeatherEntity> _weatherBox;

  // Save weather data
  @override
  Future<bool> saveWeather(Weather weather) async {
    final weatherEntity = WeatherEntity.fromWeather(weather);

    // Check if entry exists for these coordinates
    final coordinatesString = weather.coord.toString();
    final query =
        _weatherBox
            .query(WeatherEntity_.coordinates.equals(coordinatesString))
            .build();

    final existingEntity = query.findFirst();
    query.close();

    if (existingEntity != null) {
      // Update existing entry
      weatherEntity.id = existingEntity.id;
    }

    _weatherBox.put(weatherEntity);
    return true;
  }

  // Get weather for coordinates
  @override
  Weather? getWeather(double lat, double lon) {
    final coordinatesString = '[$lat, $lon]';
    final query =
        _weatherBox
            .query(WeatherEntity_.coordinates.equals(coordinatesString))
            .build();

    final entity = query.findFirst();
    query.close();

    if (entity != null && !entity.isStale) {
      return entity.toWeather();
    }

    return null;
  }

  // Get the timestamp of when the weather was last updated
  @override
  int? getLastUpdatedTimestamp(double lat, double lon) {
    final coordinatesString = '[$lat, $lon]';
    final query =
        _weatherBox
            .query(WeatherEntity_.coordinates.equals(coordinatesString))
            .build();

    final entity = query.findFirst();
    query.close();

    return entity?.timestamp;
  }
}
