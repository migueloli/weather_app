import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/city_repository_interface.dart';

class SearchCitiesUseCase {
  const SearchCitiesUseCase(this._cityRepository);

  final CityRepositoryInterface _cityRepository;

  Future<Result<List<City>, AppException>> call(String query) {
    if (query.trim().isEmpty) {
      return Future.value(Result.success([]));
    }
    return _cityRepository.searchCities(query);
  }
}
