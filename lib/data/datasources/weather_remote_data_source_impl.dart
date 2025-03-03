import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/data/datasources/contracts/weather_remote_data_source.dart';
import 'package:weather_app/data/models/weather.dart';

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  WeatherRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;
  final String baseUrl = '/data/2.5';

  @override
  Future<Weather> getWeather({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
  }) async {
    // Build query parameters
    final queryParams = <String, dynamic>{
      'lat': lat.toString(),
      'lon': lon.toString(),
      'units': units,
    };

    // Add optional language parameter if provided
    if (lang != null) {
      queryParams['lang'] = lang;
    }

    // Make API call
    final response = await _apiClient.get(
      '$baseUrl/weather',
      queryParameters: queryParams,
    );

    // Parse and return weather data
    return Weather.fromJson(response);
  }
}
