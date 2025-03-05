import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/data/models/weather.dart';

enum HomeWeatherStatus { initial, loading, success, failure }

class HomeWeatherState extends Equatable {
  const HomeWeatherState({
    this.status = HomeWeatherStatus.initial,
    this.weather,
    this.error,
  });

  final HomeWeatherStatus status;
  final Weather? weather;
  final AppException? error;

  HomeWeatherState copyWith({
    HomeWeatherStatus? status,
    Weather? weather,
    bool? isLoading,
    ValueGetter<AppException?>? error,
  }) {
    return HomeWeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [status, weather, error];
}
