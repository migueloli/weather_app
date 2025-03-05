import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/di/service_locator.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_bloc.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_event.dart';
import 'package:weather_app/presentation/weather_details/widget/weather_details_body.dart';

class WeatherDetailsScreen extends StatelessWidget {
  const WeatherDetailsScreen({
    required this.lat,
    required this.long,
    required this.cityName,
    super.key,
  });

  final double lat;
  final double long;
  final String? cityName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => WeatherDetailsBloc(
            getWeatherUseCase: getIt(),
            getForecastUseCase: getIt(),
          )..add(LoadWeatherDetails(lat: lat, lon: long)),
      child: Scaffold(
        body: WeatherDetailsBody(lat: lat, long: long, cityName: cityName),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('lat', lat));
    properties.add(DoubleProperty('long', long));
    properties.add(StringProperty('cityName', cityName));
  }
}
