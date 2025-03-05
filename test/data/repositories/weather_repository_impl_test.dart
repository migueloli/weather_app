import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/error/network_exception.dart';
import 'package:weather_app/core/network/connectivity_service.dart';
import 'package:weather_app/data/datasources/contracts/weather_local_data_source.dart';
import 'package:weather_app/data/datasources/contracts/weather_remote_data_source.dart';
import 'package:weather_app/data/models/forecast.dart';
import 'package:weather_app/data/models/forecast_city.dart';
import 'package:weather_app/data/models/forecast_entry.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/data/models/weather_clouds.dart';
import 'package:weather_app/data/models/weather_condition.dart';
import 'package:weather_app/data/models/weather_coordinates.dart';
import 'package:weather_app/data/models/weather_main.dart';
import 'package:weather_app/data/models/weather_sys.dart';
import 'package:weather_app/data/models/weather_wind.dart';
import 'package:weather_app/data/repositories/weather_repository_impl.dart';

// Create mocks
class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

class MockWeatherLocalDataSource extends Mock
    implements WeatherLocalDataSource {}

class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherRemoteDataSource mockRemoteDataSource;
  late MockWeatherLocalDataSource mockLocalDataSource;
  late MockConnectivityService mockConnectivityService;

  Weather createTestWeather({double lat = 40.7128, double lon = -74.0060}) {
    return Weather(
      coord: WeatherCoordinates(lat: lat, lon: lon),
      weather: [
        const WeatherCondition(
          id: 800,
          main: 'Clear',
          description: 'clear sky',
          icon: '01d',
        ),
      ],
      base: 'stations',
      main: const WeatherMain(
        temp: 22.5,
        feelsLike: 21.8,
        tempMin: 20,
        tempMax: 25,
        pressure: 1015,
        humidity: 55,
      ),
      visibility: 10000,
      wind: const WeatherWind(speed: 3.6, deg: 160),
      clouds: const WeatherClouds(all: 0),
      dt: 1631234567,
      sys: const WeatherSys(
        type: 1,
        id: 5122,
        country: 'US',
        sunrise: 1631234000,
        sunset: 1631280000,
      ),
      timezone: -14400,
      id: 5128581,
      name: 'New York',
      cod: 200,
    );
  }

  Forecast createTestForecast() {
    return const Forecast(
      list: [
        ForecastEntry(
          dt: 1631234567,
          main: WeatherMain(
            temp: 22.5,
            feelsLike: 21.8,
            tempMin: 20,
            tempMax: 25,
            pressure: 1015,
            humidity: 55,
          ),
          weather: [
            WeatherCondition(
              id: 800,
              main: 'Clear',
              description: 'clear sky',
              icon: '01d',
            ),
          ],
          wind: WeatherWind(speed: 3.6, deg: 160),
          dtTxt: '2023-09-10 12:00:00',
        ),
      ],
      city: ForecastCity(
        id: 5128581,
        name: 'New York',
        country: 'US',
        timezone: -14400,
        sunrise: 1631234000,
        sunset: 1631280000,
      ),
    );
  }

  setUp(() {
    mockRemoteDataSource = MockWeatherRemoteDataSource();
    mockLocalDataSource = MockWeatherLocalDataSource();
    mockConnectivityService = MockConnectivityService();

    when(
      () => mockConnectivityService.hasConnection(),
    ).thenAnswer((_) async => true);

    repository = WeatherRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      connectivityService: mockConnectivityService,
    );
  });

  group('getWeather', () {
    const double lat = 40.7128;
    const double lon = -74.0060;
    const String lang = 'en';

    test(
      'should return cached weather when available and not forced to refresh',
      () async {
        // Arrange
        final tWeather = createTestWeather();

        when(
          () => mockLocalDataSource.getWeather(lat, lon),
        ).thenAnswer((_) => tWeather);
        when(
          () => mockLocalDataSource.saveWeather(tWeather),
        ).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.getWeather(lat: lat, lon: lon, lang: lang),
        ).thenAnswer((_) async => tWeather);

        // Act
        final result = await repository.getWeather(
          lat: lat,
          lon: lon,
          lang: lang,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals(tWeather));

        // Verify cache was checked
        verify(() => mockLocalDataSource.getWeather(lat, lon)).called(1);
      },
    );

    test('should fetch from network when cache is not available', () async {
      // Arrange
      final tWeather = createTestWeather();

      // No cached weather
      when(
        () => mockLocalDataSource.getWeather(lat, lon),
      ).thenAnswer((_) => null);

      // Remote data source returns weather
      when(
        () => mockRemoteDataSource.getWeather(
          lat: any(named: 'lat'),
          lon: any(named: 'lon'),
          units: any(named: 'units'),
          lang: any(named: 'lang'),
        ),
      ).thenAnswer((_) async => tWeather);

      // Local data source saves weather
      when(
        () => mockLocalDataSource.saveWeather(tWeather),
      ).thenAnswer((_) async => true);

      // Act
      final result = await repository.getWeather(
        lat: lat,
        lon: lon,
        lang: lang,
      );

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.value, equals(tWeather));

      // Verify cache was checked
      verify(() => mockLocalDataSource.getWeather(lat, lon)).called(1);

      // Verify network calls
      verify(() => mockConnectivityService.hasConnection()).called(1);
      verify(
        () => mockRemoteDataSource.getWeather(lat: lat, lon: lon, lang: lang),
      ).called(1);

      // Verify cache was updated
      verify(() => mockLocalDataSource.saveWeather(tWeather)).called(1);
    });

    test(
      'should force refresh from network when forceRefresh is true',
      () async {
        // Arrange
        final tWeather = createTestWeather();

        // Has network connection
        when(
          () => mockConnectivityService.hasConnection(),
        ).thenAnswer((_) async => true);

        // Remote data source returns weather
        when(
          () => mockRemoteDataSource.getWeather(
            lat: any(named: 'lat'),
            lon: any(named: 'lon'),
            units: any(named: 'units'),
            lang: any(named: 'lang'),
          ),
        ).thenAnswer((_) async => tWeather);

        // Local data source saves weather
        when(
          () => mockLocalDataSource.saveWeather(tWeather),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.getWeather(
          lat: lat,
          lon: lon,
          lang: lang,
          forceRefresh: true,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals(tWeather));

        // Verify cache was NOT checked (due to forceRefresh)
        verifyNever(() => mockLocalDataSource.getWeather(lat, lon));

        // Verify network calls
        verify(() => mockConnectivityService.hasConnection()).called(1);
        verify(
          () => mockRemoteDataSource.getWeather(lat: lat, lon: lon, lang: lang),
        ).called(1);

        // Verify cache was updated
        verify(() => mockLocalDataSource.saveWeather(tWeather)).called(1);
      },
    );

    test('should return network error when no connection available', () async {
      // Arrange
      // No cached weather
      when(
        () => mockLocalDataSource.getWeather(lat, lon),
      ).thenAnswer((_) => null);

      // No network connection
      when(
        () => mockConnectivityService.hasConnection(),
      ).thenAnswer((_) async => false);

      // Act
      final result = await repository.getWeather(
        lat: lat,
        lon: lon,
        lang: lang,
      );

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.error, isA<NetworkException>());

      // Verify cache was checked
      verify(() => mockLocalDataSource.getWeather(lat, lon)).called(1);

      // Verify network check
      verify(() => mockConnectivityService.hasConnection()).called(1);

      // Verify no remote call attempted
      verifyNever(
        () => mockRemoteDataSource.getWeather(
          lat: any(named: 'lat'),
          lon: any(named: 'lon'),
        ),
      );
    });

    test('should handle exceptions from remote data source', () async {
      // Arrange
      // No cached weather
      when(
        () => mockLocalDataSource.getWeather(lat, lon),
      ).thenAnswer((_) => null);

      // Has network connection
      when(
        () => mockConnectivityService.hasConnection(),
      ).thenAnswer((_) async => true);

      // Remote data source throws exception
      when(
        () => mockRemoteDataSource.getWeather(
          lat: any(named: 'lat'),
          lon: any(named: 'lon'),
          units: any(named: 'units'),
          lang: any(named: 'lang'),
        ),
      ).thenThrow(Exception('API error'));

      // Act
      final result = await repository.getWeather(
        lat: lat,
        lon: lon,
        lang: lang,
      );

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.error, isA<AppException>());

      // Verify cache was checked
      verify(() => mockLocalDataSource.getWeather(lat, lon)).called(1);

      // Verify network calls
      verify(() => mockConnectivityService.hasConnection()).called(1);
      verify(
        () => mockRemoteDataSource.getWeather(lat: lat, lon: lon, lang: lang),
      ).called(1);
    });

    test(
      'should refresh weather in background when cached data is returned',
      () async {
        // Arrange
        final tWeather = createTestWeather();
        final tNewWeather = createTestWeather();

        // Cached weather available
        when(
          () => mockLocalDataSource.getWeather(lat, lon),
        ).thenAnswer((_) => tWeather);

        // Has network connection for background refresh
        when(
          () => mockConnectivityService.hasConnection(),
        ).thenAnswer((_) async => true);

        // Remote data source returns updated weather
        when(
          () => mockRemoteDataSource.getWeather(
            lat: any(named: 'lat'),
            lon: any(named: 'lon'),
            units: any(named: 'units'),
            lang: any(named: 'lang'),
          ),
        ).thenAnswer((_) async => tNewWeather);

        // Local data source saves weather
        when(
          () => mockLocalDataSource.saveWeather(tNewWeather),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.getWeather(
          lat: lat,
          lon: lon,
          lang: lang,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.value,
          equals(tWeather),
        ); // Should return cached data immediately

        // Wait for background refresh
        await Future.delayed(const Duration(milliseconds: 100));

        // Verify background refresh happened
        verify(() => mockConnectivityService.hasConnection()).called(1);
        verify(
          () => mockRemoteDataSource.getWeather(lat: lat, lon: lon, lang: lang),
        ).called(1);
        verify(() => mockLocalDataSource.saveWeather(tNewWeather)).called(1);
      },
    );
  });

  group('getForecast', () {
    const double lat = 40.7128;
    const double lon = -74.0060;

    test(
      'should return forecast from remote data source when connected',
      () async {
        // Arrange
        final tForecast = createTestForecast();

        // Has network connection
        when(
          () => mockConnectivityService.hasConnection(),
        ).thenAnswer((_) async => true);

        // Remote data source returns forecast
        when(
          () => mockRemoteDataSource.getForecast(
            lat: any(named: 'lat'),
            lon: any(named: 'lon'),
            units: any(named: 'units'),
            lang: any(named: 'lang'),
          ),
        ).thenAnswer((_) async => tForecast);

        // Act
        final result = await repository.getForecast(lat: lat, lon: lon);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals(tForecast));

        // Verify network check
        verify(() => mockConnectivityService.hasConnection()).called(1);

        // Verify remote data source call
        verify(
          () => mockRemoteDataSource.getForecast(lat: lat, lon: lon),
        ).called(1);
      },
    );

    test('should return network error when no connection available', () async {
      // Arrange
      // No network connection
      when(
        () => mockConnectivityService.hasConnection(),
      ).thenAnswer((_) async => false);

      // Act
      final result = await repository.getForecast(lat: lat, lon: lon);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.error, isA<NetworkException>());

      // Verify network check
      verify(() => mockConnectivityService.hasConnection()).called(1);

      // Verify no remote call attempted
      verifyNever(
        () => mockRemoteDataSource.getForecast(
          lat: any(named: 'lat'),
          lon: any(named: 'lon'),
        ),
      );
    });

    test('should handle exceptions from remote data source', () async {
      // Arrange
      // Has network connection
      when(
        () => mockConnectivityService.hasConnection(),
      ).thenAnswer((_) async => true);

      // Remote data source throws exception
      when(
        () => mockRemoteDataSource.getForecast(
          lat: any(named: 'lat'),
          lon: any(named: 'lon'),
          units: any(named: 'units'),
          lang: any(named: 'lang'),
        ),
      ).thenThrow(Exception('API error'));

      // Act
      final result = await repository.getForecast(lat: lat, lon: lon);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.error, isA<AppException>());

      // Verify network calls
      verify(() => mockConnectivityService.hasConnection()).called(1);
      verify(
        () => mockRemoteDataSource.getForecast(lat: lat, lon: lon),
      ).called(1);
    });

    test('should pass custom units and language parameters', () async {
      // Arrange
      final tForecast = createTestForecast();
      const customUnits = 'imperial';
      const customLang = 'es';

      // Has network connection
      when(
        () => mockConnectivityService.hasConnection(),
      ).thenAnswer((_) async => true);

      // Remote data source returns forecast
      when(
        () => mockRemoteDataSource.getForecast(
          lat: any(named: 'lat'),
          lon: any(named: 'lon'),
          units: any(named: 'units'),
          lang: any(named: 'lang'),
        ),
      ).thenAnswer((_) async => tForecast);

      // Act
      final result = await repository.getForecast(
        lat: lat,
        lon: lon,
        units: customUnits,
        lang: customLang,
      );

      // Assert
      expect(result.isSuccess, isTrue);

      // Verify custom parameters were passed
      verify(
        () => mockRemoteDataSource.getForecast(
          lat: lat,
          lon: lon,
          units: customUnits,
          lang: customLang,
        ),
      ).called(1);
    });
  });

  group('getLastUpdatedTimestamp', () {
    const double lat = 40.7128;
    const double lon = -74.0060;

    test('should return timestamp from local data source', () async {
      // Arrange
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      when(
        () => mockLocalDataSource.getLastUpdatedTimestamp(lat, lon),
      ).thenAnswer((_) => timestamp);

      // Act
      final result = await repository.getLastUpdatedTimestamp(lat, lon);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.value, equals(timestamp));

      // Verify local data source call
      verify(
        () => mockLocalDataSource.getLastUpdatedTimestamp(lat, lon),
      ).called(1);
    });

    test('should return null when no timestamp is available', () async {
      // Arrange
      when(
        () => mockLocalDataSource.getLastUpdatedTimestamp(lat, lon),
      ).thenAnswer((_) => null);

      // Act
      final result = await repository.getLastUpdatedTimestamp(lat, lon);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.value, isNull);

      // Verify local data source call
      verify(
        () => mockLocalDataSource.getLastUpdatedTimestamp(lat, lon),
      ).called(1);
    });

    test('should handle exceptions from local data source', () async {
      // Arrange
      when(
        () => mockLocalDataSource.getLastUpdatedTimestamp(lat, lon),
      ).thenThrow(Exception('Storage error'));

      // Act
      final result = await repository.getLastUpdatedTimestamp(lat, lon);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.error, isA<AppException>());

      // Verify local data source call
      verify(
        () => mockLocalDataSource.getLastUpdatedTimestamp(lat, lon),
      ).called(1);
    });
  });
}
