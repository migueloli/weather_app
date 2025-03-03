import 'package:weather_app/data/datasources/contracts/city_local_data_source.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/local_city_repository_interface.dart';

class LocalCityRepository implements LocalCityRepositoryInterface {
  LocalCityRepository({required CityLocalDataSource localDataSource})
    : _localDataSource = localDataSource;
  final CityLocalDataSource _localDataSource;

  @override
  Future<bool> saveCity(City city) {
    return _localDataSource.saveCity(city);
  }

  @override
  Future<bool> removeCity(double lat, double lon) {
    return _localDataSource.removeCity(lat, lon);
  }

  @override
  List<City> getAllCities({bool sortByRecent = true}) {
    return _localDataSource.getAllCities(sortByRecent: sortByRecent);
  }

  @override
  bool isCitySaved(double lat, double lon) {
    return _localDataSource.isCitySaved(lat, lon);
  }

  @override
  int getCityCount() {
    return _localDataSource.getCityCount();
  }
}
