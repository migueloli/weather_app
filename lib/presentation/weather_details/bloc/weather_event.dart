import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class FetchWeather extends WeatherEvent {
  const FetchWeather({
    required this.lat,
    required this.lon,
    this.units = 'metric',
    this.lang,
  });
  final double lat;
  final double lon;
  final String units;
  final String? lang;

  @override
  List<Object?> get props => [lat, lon, units, lang];
}

class ResetWeather extends WeatherEvent {}
