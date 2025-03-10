import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/data/models/weather.dart';

enum WeatherDetailsStatus { initial, loading, success, failure }

class WeatherDetailsState extends Equatable {
  const WeatherDetailsState({
    this.status = WeatherDetailsStatus.initial,
    this.weather,
    this.error,
  });

  final WeatherDetailsStatus status;
  final Weather? weather;
  final AppException? error;

  WeatherDetailsState copyWith({
    WeatherDetailsStatus? status,
    Weather? weather,
    ValueGetter<AppException?>? error,
  }) {
    return WeatherDetailsState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [status, weather, error];
}
