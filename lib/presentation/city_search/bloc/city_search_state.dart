import 'package:equatable/equatable.dart';
import 'package:weather_app/core/exception/app_exception.dart';
import 'package:weather_app/data/models/city.dart';

enum CitySearchStatus { initial, loading, success, failure }

class CitySearchState extends Equatable {
  const CitySearchState({
    this.status = CitySearchStatus.initial,
    this.cities = const [],
    this.query = '',
    this.error,
  });

  final CitySearchStatus status;
  final List<City> cities;
  final String query;
  final AppException? error;

  CitySearchState copyWith({
    CitySearchStatus? status,
    List<City>? cities,
    String? query,
    AppException? error,
  }) {
    return CitySearchState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      query: query ?? this.query,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, cities, query, error];
}
