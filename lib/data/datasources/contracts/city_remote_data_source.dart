import 'package:weather_app/data/models/city.dart';

abstract class CityRemoteDataSource {
  const CityRemoteDataSource();

  Future<List<City>> searchCities(String query, {int limit = 5});
}
