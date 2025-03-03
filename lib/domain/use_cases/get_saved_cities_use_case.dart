import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/local_city_repository_interface.dart';

class GetSavedCitiesUseCase {
  const GetSavedCitiesUseCase({
    required LocalCityRepositoryInterface localCityRepository,
  }) : _localCityRepository = localCityRepository;

  final LocalCityRepositoryInterface _localCityRepository;

  Stream<List<City>> call() {
    return _localCityRepository.getAllCitiesStream();
  }
}
