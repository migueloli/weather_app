import 'package:weather_app/data/models/city.dart';

abstract class CityRepositoryInterface {
  const CityRepositoryInterface();

  Future<List<City>> searchCities(String query);
}
