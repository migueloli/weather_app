import 'package:weather_app/data/models/city.dart';

abstract class CityRemoteDataSource {
  Future<List<City>> searchCities(String query, {int limit = 5});
}
