import 'package:weather_app/data/models/city.dart';

abstract class LocalCityRepositoryInterface {
  const LocalCityRepositoryInterface();

  Future<bool> saveCity(City city);
  Future<bool> removeCity(City city);
  List<City> getAllCities({bool sortByRecent = true});
  Stream<List<City>> getAllCitiesStream();
  bool isCitySaved(double lat, double lon);
  int getCityCount();
}
