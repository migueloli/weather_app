import 'package:equatable/equatable.dart';

abstract class WeatherForecastEvent extends Equatable {
  const WeatherForecastEvent();

  @override
  List<Object?> get props => [];
}

class LoadWeatherForecast extends WeatherForecastEvent {
  const LoadWeatherForecast();
}

class RefreshWeatherForecast extends WeatherForecastEvent {
  const RefreshWeatherForecast();
}
