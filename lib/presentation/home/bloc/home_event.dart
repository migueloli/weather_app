import 'package:equatable/equatable.dart';
import 'package:weather_app/data/models/city.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class RefreshSavedCities extends HomeEvent {
  const RefreshSavedCities();
}

class RemoveSavedCity extends HomeEvent {
  const RemoveSavedCity({required this.city});

  final City city;

  @override
  List<Object?> get props => [city];
}

class FetchWeatherForCity extends HomeEvent {
  const FetchWeatherForCity({required this.city});

  final City city;

  @override
  List<Object?> get props => [city];
}

class CitiesUpdated extends HomeEvent {
  const CitiesUpdated(this.cities);

  final List<City> cities;

  @override
  List<Object?> get props => [cities];
}
