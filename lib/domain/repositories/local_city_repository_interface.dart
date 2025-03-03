import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/city.dart';

abstract class LocalCityRepositoryInterface {
  const LocalCityRepositoryInterface();

  Future<Result<bool, AppException>> saveCity(City city);
  Future<Result<bool, AppException>> removeCity(City city);
  Result<List<City>, AppException> getAllCities({bool sortByRecent = true});
  Result<Stream<List<City>>, AppException> getAllCitiesStream();
  Result<bool, AppException> isCitySaved(double lat, double lon);
  Result<int, AppException> getCityCount();
}
