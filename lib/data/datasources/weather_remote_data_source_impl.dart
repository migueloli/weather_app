import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/data/datasources/contracts/weather_remote_data_source.dart';
import 'package:weather_app/data/models/forecast.dart';
import 'package:weather_app/data/models/weather.dart';

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  const WeatherRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;
  static const String _baseUrl = '/data/2.5';

  @override
  Future<Weather> getWeather({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
  }) async {
    final queryParams = <String, dynamic>{
      'lat': lat.toString(),
      'lon': lon.toString(),
      'units': units,
    };

    if (lang != null) {
      queryParams['lang'] = lang;
    }

    final response = await _apiClient.get(
      '$_baseUrl/weather',
      queryParameters: queryParams,
    );

    return Weather.fromJson(response);
  }

  @override
  Future<Forecast> getForecast({
    required double lat,
    required double lon,
    String units = 'metric',
    String? lang,
    int cnt = 40,
  }) async {
    final params = {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'units': units,
      'cnt': cnt.toString(),
    };

    if (lang != null) {
      params['lang'] = lang;
    }

    final response = await _apiClient.get(
      '$_baseUrl/forecast',
      queryParameters: params,
    );

    return Forecast.fromJson(response);
  }
}
