import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/city_repository_interface.dart';

class SearchCitiesUseCase {
  const SearchCitiesUseCase(this._cityRepository);

  final CityRepositoryInterface _cityRepository;

  Future<List<City>> call(String query) {
    if (query.trim().isEmpty) {
      return Future.value([]);
    }
    return _cityRepository.searchCities(query);
  }
}
