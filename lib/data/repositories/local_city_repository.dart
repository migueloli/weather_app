import 'package:weather_app/data/datasources/contracts/city_local_data_source.dart';
import 'package:weather_app/data/entity/city_entity.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/local_city_repository_interface.dart';

class LocalCityRepository implements LocalCityRepositoryInterface {
  const LocalCityRepository({required CityLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final CityLocalDataSource _localDataSource;

  @override
  Future<bool> saveCity(City city) {
    return _localDataSource.saveCity(CityEntity.fromCity(city));
  }

  @override
  Future<bool> removeCity(City city) {
    return _localDataSource.removeCity(city.lat, city.lon);
  }

  @override
  List<City> getAllCities({bool sortByRecent = true}) {
    return _localDataSource
        .getAllCities(sortByRecent: sortByRecent)
        .map((city) => city.toCity())
        .toList();
  }

  @override
  bool isCitySaved(double lat, double lon) {
    return _localDataSource.isCitySaved(lat, lon);
  }

  @override
  int getCityCount() {
    return _localDataSource.getCityCount();
  }

  @override
  Stream<List<City>> getAllCitiesStream() {
    return _localDataSource.getSavedCitiesStream().map(
      (city) => city.map((e) => e.toCity()).toList(),
    );
  }
}
