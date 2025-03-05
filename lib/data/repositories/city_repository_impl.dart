import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/core/error/network_exception.dart';
import 'package:weather_app/core/network/connectivity_service.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/datasources/contracts/city_remote_data_source.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/city_repository.dart';

class CityRepositoryImpl implements CityRepository {
  const CityRepositoryImpl({
    required CityRemoteDataSource remoteDataSource,
    required ConnectivityService connectivityService,
  }) : _remoteDataSource = remoteDataSource,
       _connectivityService = connectivityService;

  final CityRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivityService;

  @override
  Future<Result<List<City>, AppException>> searchCities(String query) async {
    try {
      if (!await _connectivityService.hasConnection()) {
        throw const NetworkException();
      }
      return Result.success(await _remoteDataSource.searchCities(query));
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }
}
