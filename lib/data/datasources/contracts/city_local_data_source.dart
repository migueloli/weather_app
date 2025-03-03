import 'package:weather_app/data/entity/city_entity.dart';

abstract class CityLocalDataSource {
  const CityLocalDataSource();

  Future<bool> saveCity(CityEntity city);
  Future<bool> removeCity(double lat, double lon);
  List<CityEntity> getAllCities({bool sortByRecent = true});
  bool isCitySaved(double lat, double lon);
  int getCityCount();
  Stream<List<CityEntity>> getSavedCitiesStream({bool sortByRecent = true});
}
