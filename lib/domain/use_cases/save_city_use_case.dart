import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/local_city_repository_interface.dart';

class SaveCityUseCase {
  const SaveCityUseCase(this._localCityRepository);

  final LocalCityRepositoryInterface _localCityRepository;

  Future<bool> call(City city) {
    return _localCityRepository.saveCity(city);
  }
}
