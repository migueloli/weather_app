import 'dart:async';

import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/datasources/contracts/weather_local_data_source.dart';
import 'package:weather_app/data/datasources/contracts/weather_remote_data_source.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/domain/repositories/weather_repository_interface.dart';

class WeatherRepository implements WeatherRepositoryInterface {
  const WeatherRepository({
    required WeatherRemoteDataSource remoteDataSource,
    required WeatherLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final WeatherRemoteDataSource _remoteDataSource;
  final WeatherLocalDataSource _localDataSource;

  @override
  Future<Result<Weather, AppException>> getWeather({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
    bool forceRefresh = false,
  }) async {
    try {
      // Check local cache first, unless force refresh is specified
      if (!forceRefresh) {
        final cachedWeather = _localDataSource.getWeather(lat, lon);
        if (cachedWeather != null) {
          // Return cached data, but still fetch fresh data in the background
          unawaited(_refreshWeatherInBackground(lat, lon, units, lang));
          return Result.success(cachedWeather);
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

      return Result.success(weather);
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
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
    } on Exception {
      // Silently fail for background updates
    }
  }

  @override
  Result<int?, AppException> getLastUpdatedTimestamp(double lat, double lon) {
    try {
      return Result.success(_localDataSource.getLastUpdatedTimestamp(lat, lon));
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }
}
