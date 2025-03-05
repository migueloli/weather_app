import 'dart:async';

import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/city_repository_interface.dart';

class SearchCitiesUseCase {
  const SearchCitiesUseCase({required CityRepositoryInterface cityRepository})
    : _cityRepository = cityRepository;

  final CityRepositoryInterface _cityRepository;

  FutureOr<Result<List<City>, AppException>> call(String query) {
    if (query.trim().isEmpty) {
      return Result.success([]);
    }
    return _cityRepository.searchCities(query);
  }
}
