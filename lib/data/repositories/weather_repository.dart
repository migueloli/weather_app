import 'dart:async';

import 'package:weather_app/data/datasources/contracts/weather_local_data_source.dart';
import 'package:weather_app/data/datasources/contracts/weather_remote_data_source.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/domain/repositories/weather_repository_interface.dart';

class WeatherRepository implements WeatherRepositoryInterface {
  WeatherRepository({
    required WeatherRemoteDataSource remoteDataSource,
    required WeatherLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;
  final WeatherRemoteDataSource _remoteDataSource;
  final WeatherLocalDataSource _localDataSource;

  @override
  Future<Weather> getWeather({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
    bool forceRefresh = false,
  }) async {
    // Check local cache first, unless force refresh is specified
    if (!forceRefresh) {
      final cachedWeather = _localDataSource.getWeather(lat, lon);
      if (cachedWeather != null) {
        // Return cached data, but still fetch fresh data in the background
        unawaited(_refreshWeatherInBackground(lat, lon, units, lang));
        return cachedWeather;
      }
    }

    // No cache or force refresh requested, fetch from API
    final weather = await _remoteDataSource.getWeather(
      lat: lat,
      lon: lon,
      units: units,
      lang: lang,
    );

    // Save to local storage
    await _localDataSource.saveWeather(weather);

    return weather;
  }

  // Helper method for background refresh
  Future<void> _refreshWeatherInBackground(
    double lat,
    double lon,
    String units,
    String? lang,
  ) async {
    try {
      final weather = await _remoteDataSource.getWeather(
        lat: lat,
        lon: lon,
        units: units,
        lang: lang,
      );

      await _localDataSource.saveWeather(weather);
    } catch (_) {
      // Silently fail for background updates
    }
  }

  @override
  int? getLastUpdatedTimestamp(double lat, double lon) {
    return _localDataSource.getLastUpdatedTimestamp(lat, lon);
  }
}
