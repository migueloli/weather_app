import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/data/datasources/contracts/city_remote_data_source.dart';
import 'package:weather_app/data/models/city.dart';

class CityRemoteDataSourceImpl implements CityRemoteDataSource {
  const CityRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;
  static const String _basePath = 'geo/1.0';

  @override
  Future<List<City>> searchCities(String cityName, {int limit = 5}) async {
    final response = await _apiClient.get(
      '$_basePath/direct',
      queryParameters: {'q': cityName, 'limit': limit.toString()},
    );

    if (response is List) {
      return response.map((cityJson) => City.fromJson(cityJson)).toList();
    }

    return [];
  }
}
