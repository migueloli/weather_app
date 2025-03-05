import 'package:equatable/equatable.dart';
import 'package:weather_app/data/models/weather_condition.dart';
import 'package:weather_app/data/models/weather_main.dart';
import 'package:weather_app/data/models/weather_wind.dart';

class ForecastEntry extends Equatable {
  const ForecastEntry({
    required this.dt,
    required this.main,
    required this.weather,
    required this.wind,
    required this.dtTxt,
  });

  factory ForecastEntry.fromJson(Map<String, dynamic> json) {
    return ForecastEntry(
      dt: json['dt'] as int,
      main: WeatherMain.fromJson(json['main'] as Map<String, dynamic>),
      weather:
          (json['weather'] as List)
              .map((e) => WeatherCondition.fromJson(e as Map<String, dynamic>))
              .toList(),
      wind: WeatherWind.fromJson(json['wind'] as Map<String, dynamic>),
      dtTxt: json['dt_txt'] as String,
    );
  }

  final int dt;
  final WeatherMain main;
  final List<WeatherCondition> weather;
  final WeatherWind wind;
  final String dtTxt;

  @override
  List<Object?> get props => [dt, main, weather, wind, dtTxt];
}
