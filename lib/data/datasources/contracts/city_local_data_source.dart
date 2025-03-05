import 'dart:async';

import 'package:weather_app/data/entity/city_entity.dart';

abstract class CityLocalDataSource {
  const CityLocalDataSource();

  FutureOr<bool> saveCity(CityEntity city);
  FutureOr<bool> removeCity(double lat, double lon);
  FutureOr<List<CityEntity>> getAllCities({bool sortByRecent = true});
  FutureOr<bool> isCitySaved(double lat, double lon);
  FutureOr<int> getCityCount();
  Stream<List<CityEntity>> getSavedCitiesStream({bool sortByRecent = true});
}
