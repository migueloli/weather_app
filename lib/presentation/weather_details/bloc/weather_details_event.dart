import 'package:equatable/equatable.dart';

abstract class WeatherDetailsEvent extends Equatable {
  const WeatherDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadWeatherDetails extends WeatherDetailsEvent {
  const LoadWeatherDetails();
}

class RefreshWeatherDetails extends WeatherDetailsEvent {
  const RefreshWeatherDetails();
}
