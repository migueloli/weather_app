import 'package:equatable/equatable.dart';

abstract class HomeWeatherEvent extends Equatable {
  const HomeWeatherEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeWeather extends HomeWeatherEvent {
  const LoadHomeWeather();
}

class RefreshHomeWeather extends HomeWeatherEvent {
  const RefreshHomeWeather();
}
