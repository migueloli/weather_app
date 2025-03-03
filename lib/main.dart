import 'package:flutter/material.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/core/config/env_config.dart';
import 'package:weather_app/core/di/service_locator.dart';
import 'package:weather_app/core/error/error_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvConfig.initialize();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    ErrorHandler.handleError(details.exception, details.stack);
  };
  await setupDependencies();

  runApp(const WeatherApp());
}
