import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/data/models/forecast.dart';
import 'package:weather_app/data/models/weather.dart';

enum WeatherForecastStatus { initial, loading, success, failure }

class WeatherForecastState extends Equatable {
  const WeatherForecastState({
    this.status = WeatherForecastStatus.initial,
    this.forecast,
    this.error,
  });

  final WeatherForecastStatus status;
  final Forecast? forecast;
  final AppException? error;

  WeatherForecastState copyWith({
    WeatherForecastStatus? status,
    Weather? weather,
    Forecast? forecast,
    ValueGetter<AppException?>? error,
  }) {
    return WeatherForecastState(
      status: status ?? this.status,
      forecast: forecast ?? forecast,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [status, forecast, error];
}
