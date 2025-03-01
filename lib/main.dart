import 'package:flutter/material.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Add global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };
  setupDependencies();

  runApp(const WeatherApp());
}
