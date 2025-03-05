import 'package:equatable/equatable.dart';

class ForecastCity extends Equatable {
  const ForecastCity({
    required this.id,
    required this.name,
    required this.country,
    required this.timezone,
    required this.sunrise,
    required this.sunset,
  });

  factory ForecastCity.fromJson(Map<String, dynamic> json) {
    return ForecastCity(
      id: json['id'] as int,
      name: json['name'] as String,
      country: json['country'] as String,
      timezone: json['timezone'] as int,
      sunrise: json['sunrise'] as int,
      sunset: json['sunset'] as int,
    );
  }

  final int id;
  final String name;
  final String country;
  final int timezone;
  final int sunrise;
  final int sunset;

  @override
  List<Object?> get props => [id, name, country, timezone, sunrise, sunset];
}
