import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/local_city_repository_interface.dart';

class GetSavedCitiesUseCase {
  const GetSavedCitiesUseCase({
    required LocalCityRepositoryInterface localCityRepository,
  }) : _localCityRepository = localCityRepository;

  final LocalCityRepositoryInterface _localCityRepository;

  Result<Stream<List<City>>, AppException> call() {
    return _localCityRepository.getAllCitiesStream();
  }
}
