import 'package:weather_app/data/models/json_list.dart';
import 'package:weather_app/data/models/weather_clouds.dart';
import 'package:weather_app/data/models/weather_condition.dart';
import 'package:weather_app/data/models/weather_coordinates.dart';
import 'package:weather_app/data/models/weather_main.dart';
import 'package:weather_app/data/models/weather_rain.dart';
import 'package:weather_app/data/models/weather_sys.dart';
import 'package:weather_app/data/models/weather_wind.dart';

class Weather {
  Weather({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
    this.rain,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      coord: WeatherCoordinates.fromJson(json['coord']),
      weather:
          (json['weather'] as JsonList).map(WeatherCondition.fromJson).toList(),
      base: json['base'],
      main: WeatherMain.fromJson(json['main']),
      visibility: json['visibility'],
      wind: WeatherWind.fromJson(json['wind']),
      rain: json['rain'] != null ? WeatherRain.fromJson(json['rain']) : null,
      clouds: WeatherClouds.fromJson(json['clouds']),
      dt: json['dt'],
      sys: WeatherSys.fromJson(json['sys']),
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
    );
  }
  final WeatherCoordinates coord;
  final List<WeatherCondition> weather;
  final String base;
  final WeatherMain main;
  final int visibility;
  final WeatherWind wind;
  final WeatherRain? rain;
  final WeatherClouds clouds;
  final int dt;
  final WeatherSys sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;

  Map<String, dynamic> toJson() {
    return {
      'coord': coord.toJson(),
      'weather': weather.map((w) => w.toJson()).toList(),
      'base': base,
      'main': main.toJson(),
      'visibility': visibility,
      'wind': wind.toJson(),
      'rain': rain?.toJson(),
      'clouds': clouds.toJson(),
      'dt': dt,
      'sys': sys.toJson(),
      'timezone': timezone,
      'id': id,
      'name': name,
      'cod': cod,
    };
  }
}
