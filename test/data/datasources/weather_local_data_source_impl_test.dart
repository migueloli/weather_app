import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/data/datasources/weather_local_data_source_impl.dart';
import 'package:weather_app/data/entity/weather_entity.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/data/models/weather_clouds.dart';
import 'package:weather_app/data/models/weather_condition.dart';
import 'package:weather_app/data/models/weather_coordinates.dart';
import 'package:weather_app/data/models/weather_main.dart';
import 'package:weather_app/data/models/weather_sys.dart';
import 'package:weather_app/data/models/weather_wind.dart';
import 'package:weather_app/objectbox.g.dart';

import '../../fixtures/weather_data.dart';

class MockStore extends Mock implements Store {}

class MockBox<T> extends Mock implements Box<T> {}

class MockQuery<T> extends Mock implements Query<T> {}

class MockQueryBuilder<T> extends Mock implements QueryBuilder<T> {}

// Create a custom matcher for the query conditions
class QueryConditionMatcher extends Matcher {
  QueryConditionMatcher(this.propertyName, this.expectedValue);
  final String propertyName;
  final String expectedValue;

  @override
  bool matches(dynamic item, Map matchState) {
    // In a real test, you'd check more thoroughly
    // This is a simplified version
    return true;
  }

  @override
  Description describe(Description description) {
    return description.add(
      'is a query condition for $propertyName with value $expectedValue',
    );
  }
}

void main() {
  late WeatherLocalDataSourceImpl dataSource;
  late MockStore mockStore;
  late MockBox<WeatherEntity> mockWeatherBox;
  late MockQuery<WeatherEntity> mockQuery;
  late MockQueryBuilder<WeatherEntity> mockQueryBuilder;

  Weather createTestWeather({double lat = 40.7128, double long = -74.0060}) {
    return Weather(
      coord: WeatherCoordinates(lat: lat, lon: long),
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

  WeatherEntity createTestWeatherEntity({
    int id = 123,
    double lat = 40.7128,
    double long = -74.0060,
    int? timestamp,
  }) {
    return WeatherEntity(
      id: id,
      lat: lat,
      lon: long,
      weatherData: weatherResponseJson,
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  setUp(() {
    // Register fallback values for mocktail
    registerFallbackValue(createTestWeatherEntity(lat: 0, long: 0));
    registerFallbackValue(QueryConditionMatcher('coordinates', ''));

    mockStore = MockStore();
    mockWeatherBox = MockBox<WeatherEntity>();
    mockQuery = MockQuery<WeatherEntity>();
    mockQueryBuilder = MockQueryBuilder<WeatherEntity>();

    // Create a box for the weather entity
    when(() => mockStore.box<WeatherEntity>()).thenReturn(mockWeatherBox);

    // Handle query building
    when(() => mockWeatherBox.put(any())).thenReturn(0);
    when(() => mockWeatherBox.query(any())).thenReturn(mockQueryBuilder);
    when(() => mockQueryBuilder.build()).thenReturn(mockQuery);

    // Create our data source with the mocked store
    dataSource = WeatherLocalDataSourceImpl(store: mockStore);
  });

  group('saveWeather', () {
    test(
      'should save a new weather entity when no existing entity is found',
      () async {
        // Arrange
        final weather = createTestWeather();

        // Mock query to return no entity (not found)
        when(() => mockQuery.findFirst()).thenReturn(null);

        // Act
        final result = await dataSource.saveWeather(weather);

        // Assert
        verify(() => mockWeatherBox.query(any())).called(1);
        verify(() => mockQueryBuilder.build()).called(1);
        verify(() => mockQuery.findFirst()).called(1);
        verify(() => mockQuery.close()).called(1);

        // Verify that a new entity was saved
        verify(() => mockWeatherBox.put(any())).called(1);

        expect(result, isTrue);
      },
    );

    test(
      'should update existing weather entity when entity with same coordinates exists',
      () async {
        // Arrange
        final weather = createTestWeather();
        final existingEntity = createTestWeatherEntity(
          lat: weather.coord.lat,
          long: weather.coord.lon,
        );

        // Mock query to return existing entity
        when(() => mockQuery.findFirst()).thenReturn(existingEntity);

        // Act
        final result = await dataSource.saveWeather(weather);

        // Assert
        verify(() => mockWeatherBox.query(any())).called(1);
        verify(() => mockQueryBuilder.build()).called(1);
        verify(() => mockQuery.findFirst()).called(1);
        verify(() => mockQuery.close()).called(1);

        // Verify that the entity was updated (has the same ID)
        verify(
          () => mockWeatherBox.put(
            any(that: predicate((WeatherEntity entity) => entity.id == 123)),
          ),
        ).called(1);

        expect(result, isTrue);
      },
    );
  });

  group('getWeather', () {
    test(
      'should return Weather object when a non-stale entity is found',
      () async {
        // Arrange
        const lat = 40.7128;
        const lon = -74.0060;

        // Create a non-stale entity
        final weatherEntity = createTestWeatherEntity();

        // Mock to return non-stale entity
        when(() => mockQuery.findFirst()).thenReturn(weatherEntity);

        // Act
        final result = await dataSource.getWeather(lat, lon);

        // Assert
        expect(result, isNotNull);
        expect(result?.coord.lat, equals(lat));
        expect(result?.coord.lon, equals(lon));
      },
    );

    test('should return null when entity is stale', () async {
      // Arrange
      const lat = 40.7128;
      const lon = -74.0060;

      // Create a stale entity
      final weatherEntity = createTestWeatherEntity(
        timestamp:
            DateTime.now()
                .subtract(const Duration(days: 2))
                .millisecondsSinceEpoch,
      );

      // Mock to return stale entity
      when(() => mockQuery.findFirst()).thenReturn(weatherEntity);

      // Act
      final result = await dataSource.getWeather(lat, lon);

      // Assert
      expect(result, isNull);
    });
  });

  group('getLastUpdatedTimestamp', () {
    test('should return timestamp when entity is found', () async {
      // Arrange
      const lat = 40.7128;
      const lon = -74.0060;
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final weatherEntity = createTestWeatherEntity(timestamp: timestamp);

      // Mock to return entity
      when(() => mockQuery.findFirst()).thenReturn(weatherEntity);

      // Act
      final result = await dataSource.getLastUpdatedTimestamp(lat, lon);

      // Assert
      expect(result, equals(timestamp));
    });

    test('should return null when no entity is found', () async {
      // Arrange
      const lat = 40.7128;
      const lon = -74.0060;

      // Mock to return null (no entity)
      when(() => mockQuery.findFirst()).thenReturn(null);

      // Act
      final result = await dataSource.getLastUpdatedTimestamp(lat, lon);

      // Assert
      expect(result, isNull);
    });
  });
}
