import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/data/models/city.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.cities = const [],
    this.error,
  });

  final HomeStatus status;
  final List<City> cities;
  final AppException? error;

  HomeState copyWith({
    HomeStatus? status,
    List<City>? cities,
    ValueGetter<AppException?>? error,
  }) {
    return HomeState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [status, cities, error];
}
