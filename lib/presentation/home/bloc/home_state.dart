import 'package:equatable/equatable.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/data/models/weather.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.cities = const [],
    this.weatherData = const {},
    this.loadingWeather = const {},
    this.errorMessage,
  });

  final HomeStatus status;
  final List<City> cities;
  final Map<String, Weather> weatherData;
  final Set<String> loadingWeather;
  final String? errorMessage;

  // Get a unique key for a city based on coordinates
  static String getCityKey(double lat, double lon) => '$lat,$lon';

  // Get weather for a specific city
  Weather? getWeatherForCity(City city) {
    return weatherData[getCityKey(city.lat, city.lon)];
  }

  // Check if weather is loading for a city
  bool isLoadingWeatherForCity(City city) {
    return loadingWeather.contains(getCityKey(city.lat, city.lon));
  }

  HomeState copyWith({
    HomeStatus? status,
    List<City>? cities,
    Map<String, Weather>? weatherData,
    Set<String>? loadingWeather,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      weatherData: weatherData ?? this.weatherData,
      loadingWeather: loadingWeather ?? this.loadingWeather,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cities,
    weatherData,
    loadingWeather,
    errorMessage,
  ];
}
