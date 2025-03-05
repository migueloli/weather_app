import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/presentation/city_search/city_search_screen.dart';
import 'package:weather_app/presentation/error/error_screen.dart';
import 'package:weather_app/presentation/home/home_screen.dart';
import 'package:weather_app/presentation/settings/settings_screen.dart';
import 'package:weather_app/presentation/weather_details/weather_details_screen.dart';

part 'app_routes.dart';

abstract class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.citySearch,
        name: 'city-search',
        builder: (context, state) => const CitySearchScreen(),
      ),
      GoRoute(
        path: AppRoutes._weatherDetails,
        name: 'weather-details',
        builder:
            (context, state) => WeatherDetailsScreen(
              lat: double.parse(state.uri.queryParameters['lat']!),
              long: double.parse(state.uri.queryParameters['long']!),
              cityName: state.uri.queryParameters['cityName'],
            ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder:
        (context, state) =>
            ErrorScreen(error: ErrorHandler.handleError(state.error)),
  );
}
