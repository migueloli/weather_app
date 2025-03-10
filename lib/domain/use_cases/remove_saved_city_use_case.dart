import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/local_city_repository.dart';

class RemoveSavedCityUseCase {
  const RemoveSavedCityUseCase({
    required LocalCityRepository localCityRepository,
  }) : _localCityRepository = localCityRepository;

  final LocalCityRepository _localCityRepository;

  Future<Result<bool, AppException>> call(City city) {
    return _localCityRepository.removeCity(city);
  }
}
