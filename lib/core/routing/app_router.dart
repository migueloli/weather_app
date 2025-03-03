import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:go_router/go_router.dart';
import 'package:weather_app/presentation/city_search/city_search_screen.dart';
import 'package:weather_app/presentation/error/error_screen.dart';
import 'package:weather_app/presentation/home/home_screen.dart';

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
        path: '/city/search',
        name: 'city-search',
        builder: (context, state) => const CitySearchScreen(),
      ),
    ],
    errorBuilder:
        (context, state) => ErrorScreen(error: state.error.toString()),
  );
}
