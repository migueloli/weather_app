import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/datasources/contracts/city_remote_data_source.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/city_repository_interface.dart';

class CityRepository implements CityRepositoryInterface {
  const CityRepository({required CityRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final CityRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<City>, AppException>> searchCities(String query) async {
    try {
      return Result.success(await _remoteDataSource.searchCities(query));
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }
}
