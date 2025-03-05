import 'dart:async';

import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/datasources/contracts/city_local_data_source.dart';
import 'package:weather_app/data/entity/city_entity.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/local_city_repository_interface.dart';

class LocalCityRepository implements LocalCityRepositoryInterface {
  const LocalCityRepository({required CityLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final CityLocalDataSource _localDataSource;

  @override
  Future<Result<bool, AppException>> saveCity(City city) async {
    try {
      return Result.success(
        await _localDataSource.saveCity(CityEntity.fromCity(city)),
      );
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }

  @override
  Future<Result<bool, AppException>> removeCity(City city) async {
    try {
      return Result.success(
        await _localDataSource.removeCity(city.lat, city.lon),
      );
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }

  @override
  Future<Result<List<City>, AppException>> getAllCities({
    bool sortByRecent = true,
  }) async {
    try {
      final cities = await _localDataSource.getAllCities(
        sortByRecent: sortByRecent,
      );
      return Result.success(cities.map((city) => city.toCity()).toList());
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }

  @override
  Future<Result<bool, AppException>> isCitySaved(double lat, double lon) async {
    try {
      return Result.success(await _localDataSource.isCitySaved(lat, lon));
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }

  @override
  Future<Result<int, AppException>> getCityCount() async {
    try {
      return Result.success(await _localDataSource.getCityCount());
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }

  @override
  Result<Stream<List<City>>, AppException> getAllCitiesStream() {
    try {
      return Result.success(
        _localDataSource.getSavedCitiesStream().transform(
          StreamTransformer.fromHandlers(
            handleData: (city, sink) {
              sink.add(city.map((e) => e.toCity()).toList());
            },
          ),
        ),
      );
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }
}
