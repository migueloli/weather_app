import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:go_router/go_router.dart';
import 'package:weather_app/presentation/city_search/city_search_screen.dart';
import 'package:weather_app/presentation/error/error_screen.dart';
import 'package:weather_app/presentation/home/home_screen.dart';
import 'package:weather_app/presentation/weather_details/weather_details_screen.dart';

abstract class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/weather',
        name: 'weather-details',
        builder: (context, state) {
          return WeatherDetailsScreen(
            lat:
                double.tryParse(state.uri.queryParameters['lat'] ?? '0.0') ??
                0.0,
            lon:
                double.tryParse(state.uri.queryParameters['lon'] ?? '0.0') ??
                0.0,
          );
        },
      ),
      GoRoute(
        path: '/city/search',
        name: 'city-search',
        builder: (context, state) => const CitySearchScreen(),
      ),
    ],
    errorBuilder:
        (context, state) => ErrorScreen(error: state.error.toString()),
  );
}
