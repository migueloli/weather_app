import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/local_city_repository_interface.dart';

class ManageSavedCitiesUseCase {
  ManageSavedCitiesUseCase(this._localCityRepository);
  final LocalCityRepositoryInterface _localCityRepository;

  Future<bool> saveCity(City city) {
    return _localCityRepository.saveCity(city);
  }

  Future<bool> removeCity(double lat, double lon) {
    return _localCityRepository.removeCity(lat, lon);
  }

  List<City> getSavedCities({bool sortByRecent = true}) {
    return _localCityRepository.getAllCities(sortByRecent: sortByRecent);
  }

  bool isCitySaved(double lat, double lon) {
    return _localCityRepository.isCitySaved(lat, lon);
  }

  int getSavedCityCount() {
    return _localCityRepository.getCityCount();
  }
}
