import 'package:equatable/equatable.dart';
import 'package:weather_app/data/models/forecast_entry.dart';
import 'package:weather_app/data/models/weather_condition.dart';

class DailyForecastData extends Equatable {
  const DailyForecastData({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.weatherCondition,
    required this.entries,
  });

  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final WeatherCondition? weatherCondition;
  final List<ForecastEntry> entries;

  @override
  List<Object?> get props => [
    date,
    minTemp,
    maxTemp,
    weatherCondition,
    entries,
  ];
}
