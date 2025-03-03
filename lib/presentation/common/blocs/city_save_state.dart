import 'package:equatable/equatable.dart';
import 'package:weather_app/data/models/city.dart';

enum CitySaveStatus { initial, loading, success, failure }

class CitySaveState extends Equatable {
  const CitySaveState({
    this.status = CitySaveStatus.initial,
    this.cities = const [],
    this.errorMessage,
    this.isCurrentCitySaved = false,
  });

  final CitySaveStatus status;
  final List<City> cities;
  final String? errorMessage;
  final bool isCurrentCitySaved;

  CitySaveState copyWith({
    CitySaveStatus? status,
    List<City>? cities,
    String? errorMessage,
    bool? isCurrentCitySaved,
  }) {
    return CitySaveState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      errorMessage: errorMessage ?? this.errorMessage,
      isCurrentCitySaved: isCurrentCitySaved ?? this.isCurrentCitySaved,
    );
  }

  @override
  List<Object?> get props => [status, cities, errorMessage, isCurrentCitySaved];
}
