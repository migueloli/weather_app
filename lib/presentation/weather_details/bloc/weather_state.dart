import 'package:equatable/equatable.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/data/models/weather.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherLoaded extends WeatherState {
  const WeatherLoaded(this.weather, {this.city, this.lastUpdated});
  final Weather weather;
  final City? city;
  final DateTime? lastUpdated;

  @override
  List<Object?> get props => [weather, city, lastUpdated];
}

class WeatherError extends WeatherState {
  const WeatherError({this.errorMessage});
  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
