import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/data/models/city.dart';

class GeocodingService {
  GeocodingService({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;

  Future<List<City>> getCitiesByName(String cityName, {int limit = 5}) async {
    try {
      final response = await _apiClient.get(
        '/geo/1.0/direct',
        queryParameters: {'q': cityName, 'limit': limit.toString()},
      );

      if (response is List) {
        return response.map((cityJson) => City.fromJson(cityJson)).toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
