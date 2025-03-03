import 'package:weather_app/core/exception/api_exception.dart';
import 'package:weather_app/core/exception/network_exception.dart';
import 'package:weather_app/data/datasources/contracts/city_remote_data_source.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/repositories/city_repository_interface.dart';

class CityRepository implements CityRepositoryInterface {
  const CityRepository({required CityRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final CityRemoteDataSource _remoteDataSource;

  @override
  Future<List<City>> searchCities(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      return await _remoteDataSource.searchCities(query);
    } on NetworkException {
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
