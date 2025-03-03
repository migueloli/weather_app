import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/city.dart';

abstract class CityRepositoryInterface {
  const CityRepositoryInterface();

  Future<Result<List<City>, AppException>> searchCities(String query);
}
