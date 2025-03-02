import 'package:weather_app/core/exception/api_exception.dart';
import 'package:weather_app/core/exception/network_exception.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/data/services/geocoding_service.dart';

class CityRepository {
  CityRepository({required GeocodingService geocodingService})
    : _geocodingService = geocodingService;
  final GeocodingService _geocodingService;

  Future<List<City>> searchCities(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      return await _geocodingService.getCitiesByName(query);
    } on NetworkException {
      // In a real app, you might want to handle these differently
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
