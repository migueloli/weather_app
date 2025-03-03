import 'package:equatable/equatable.dart';
import 'package:weather_app/data/models/city.dart';

abstract class CitySaveEvent extends Equatable {
  const CitySaveEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedCities extends CitySaveEvent {}

class AddCity extends CitySaveEvent {
  const AddCity(this.city);
  final City city;

  @override
  List<Object?> get props => [city];
}

class RemoveCity extends CitySaveEvent {
  const RemoveCity({required this.lat, required this.lon});
  final double lat;
  final double lon;

  @override
  List<Object?> get props => [lat, lon];
}

class CheckCitySaved extends CitySaveEvent {
  const CheckCitySaved({required this.lat, required this.lon});
  final double lat;
  final double lon;

  @override
  List<Object?> get props => [lat, lon];
}
