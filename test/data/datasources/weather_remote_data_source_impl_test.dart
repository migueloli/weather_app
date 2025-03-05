import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/data/datasources/weather_remote_data_source_impl.dart';
import 'package:weather_app/data/models/forecast.dart';
import 'package:weather_app/data/models/weather.dart';

import '../../fixtures/weather_data.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late WeatherRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = WeatherRemoteDataSourceImpl(apiClient: mockApiClient);
    registerFallbackValue({});
  });

  group('getWeather', () {
    const double lat = 40.7128;
    const double lon = -74.0060;
    const String units = 'metric';
    const String lang = 'en';

    final tWeatherData = jsonDecode(weatherResponseJson);
    final tWeather = Weather.fromJson(tWeatherData);

    test('should call the API client with correct parameters', () async {
      // Arrange
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => tWeatherData);

      // Act
      await dataSource.getWeather(lat: lat, lon: lon, lang: lang);

      // Assert
      verify(
        () => mockApiClient.get(
          '/data/2.5/weather',
          queryParameters: {
            'lat': lat.toString(),
            'lon': lon.toString(),
            'units': units,
            'lang': lang,
          },
        ),
      ).called(1);
    });

    test('should return Weather when the call is successful', () async {
      // Arrange
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => tWeatherData);

      // Act
      final result = await dataSource.getWeather(
        lat: lat,
        lon: lon,
        lang: lang,
      );

      // Assert
      expect(result, isA<Weather>());
      expect(result.main.temp, equals(tWeather.main.temp));
      expect(result.weather.first.main, equals(tWeather.weather.first.main));
    });

    test('should not include lang parameter when lang is null', () async {
      // Arrange
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => tWeatherData);

      // Act
      await dataSource.getWeather(lat: lat, lon: lon);

      // Assert
      verify(
        () => mockApiClient.get(
          '/data/2.5/weather',
          queryParameters: {
            'lat': lat.toString(),
            'lon': lon.toString(),
            'units': units,
          },
        ),
      ).called(1);
    });

    test('should throw an exception when the API call fails', () async {
      // Arrange
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(Exception('API error'));

      // Act & Assert
      expect(
        () => dataSource.getWeather(lat: lat, lon: lon),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getForecast', () {
    const double lat = 40.7128;
    const double lon = -74.0060;

    final tForecastData = jsonDecode(forecastResponseJson);
    final tForecast = Forecast.fromJson(tForecastData);

    test('should call the API client with correct parameters', () async {
      // Arrange
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => tForecastData);

      // Act
      await dataSource.getForecast(lat: lat, lon: lon);

      // Assert
      verify(
        () => mockApiClient.get(
          '/data/2.5/forecast',
          queryParameters: {
            'lat': lat.toString(),
            'lon': lon.toString(),
            'units': 'metric',
            'cnt': '40',
          },
        ),
      ).called(1);
    });

    test('should return Forecast when the call is successful', () async {
      // Arrange
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => tForecastData);

      // Act
      final result = await dataSource.getForecast(lat: lat, lon: lon);

      // Assert
      expect(result, isA<Forecast>());
      expect(result.list.length, equals(tForecast.list.length));
      expect(result.city.name, equals(tForecast.city.name));
    });

    test('should throw an exception when the API call fails', () async {
      // Arrange
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(Exception('API error'));

      // Act & Assert
      expect(
        () => dataSource.getForecast(lat: lat, lon: lon),
        throwsA(isA<Exception>()),
      );
    });

    test('should pass custom parameters when provided', () async {
      // Arrange
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => tForecastData);

      const units = 'imperial';
      const lang = 'de';
      const cnt = 40;

      // Act
      await dataSource.getForecast(
        lat: lat,
        lon: lon,
        units: units,
        lang: lang,
      );

      // Assert
      verify(
        () => mockApiClient.get(
          '/data/2.5/forecast',
          queryParameters: {
            'lat': lat.toString(),
            'lon': lon.toString(),
            'units': units,
            'cnt': cnt.toString(),
            'lang': lang,
          },
        ),
      ).called(1);
    });
  });
}
