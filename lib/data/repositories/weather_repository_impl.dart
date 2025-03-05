import 'dart:async';

import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/core/error/network_exception.dart';
import 'package:weather_app/core/network/connectivity_service.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/datasources/contracts/weather_local_data_source.dart';
import 'package:weather_app/data/datasources/contracts/weather_remote_data_source.dart';
import 'package:weather_app/data/models/forecast.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  const WeatherRepositoryImpl({
    required WeatherRemoteDataSource remoteDataSource,
    required WeatherLocalDataSource localDataSource,
    required ConnectivityService connectivityService,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _connectivityService = connectivityService;

  final WeatherRemoteDataSource _remoteDataSource;
  final WeatherLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;

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
        final cachedWeather = await _localDataSource.getWeather(lat, lon);
        if (cachedWeather != null) {
          unawaited(_refreshWeatherInBackground(lat, lon, units, lang));
          return Result.success(cachedWeather);
        }
      }

      if (!await _connectivityService.hasConnection()) {
        throw const NetworkException();
      }

      final weather = await _remoteDataSource.getWeather(
        lat: lat,
        lon: lon,
        units: units,
        lang: lang,
      );

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
      if (!await _connectivityService.hasConnection()) {
        throw const NetworkException();
      }

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
  Future<Result<Forecast, AppException>> getForecast({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
  }) async {
    try {
      if (!await _connectivityService.hasConnection()) {
        throw const NetworkException();
      }

      final forecast = await _remoteDataSource.getForecast(
        lat: lat,
        lon: lon,
        units: units,
        lang: lang,
      );

      return Result.success(forecast);
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }

  @override
  Future<Result<int?, AppException>> getLastUpdatedTimestamp(
    double lat,
    double lon,
  ) async {
    try {
      return Result.success(
        await _localDataSource.getLastUpdatedTimestamp(lat, lon),
      );
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }
}
