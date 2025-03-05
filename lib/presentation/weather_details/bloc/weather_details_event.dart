import 'package:equatable/equatable.dart';

abstract class WeatherDetailsEvent extends Equatable {
  const WeatherDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadWeatherDetails extends WeatherDetailsEvent {
  const LoadWeatherDetails({required this.lat, required this.lon});

  final double lat;
  final double lon;

  @override
  List<Object?> get props => [lat, lon];
}

class RefreshWeatherDetails extends WeatherDetailsEvent {
  const RefreshWeatherDetails();
}
