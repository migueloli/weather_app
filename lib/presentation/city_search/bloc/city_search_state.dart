import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/data/models/city.dart';

enum CitySearchStatus { initial, loading, success, failure }

class CitySearchState extends Equatable {
  const CitySearchState({
    this.status = CitySearchStatus.initial,
    this.cities = const [],
    this.savedCities = const {},
    this.query = '',
    this.error,
  });

  final CitySearchStatus status;
  final List<City> cities;
  final Set<String> savedCities;
  final String query;
  final AppException? error;

  CitySearchState copyWith({
    CitySearchStatus? status,
    List<City>? cities,
    Set<String>? savedCities,
    String? query,
    ValueGetter<AppException?>? error,
  }) {
    return CitySearchState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      savedCities: savedCities ?? this.savedCities,
      query: query ?? this.query,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [status, cities, savedCities, query, error];
}
