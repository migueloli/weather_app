import 'package:weather_app/data/models/city.dart';

abstract class CityLocalDataSource {
  Future<bool> saveCity(City city);
  Future<bool> removeCity(double lat, double lon);
  List<City> getAllCities({bool sortByRecent = true});
  bool isCitySaved(double lat, double lon);
  int getCityCount();
}
