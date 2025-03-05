import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/city.dart';

abstract class CityRepository {
  const CityRepository();

  Future<Result<List<City>, AppException>> searchCities(String query);
}
