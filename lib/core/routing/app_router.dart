import 'package:go_router/go_router.dart';
import 'package:weather_app/presentation/error/error_screen.dart';
import 'package:weather_app/presentation/home/home_screen.dart';
import 'package:weather_app/presentation/weather_details/weather_details_screen.dart';

abstract class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/weather/:cityId',
        name: 'weather-details',
        builder: (context, state) {
          final cityId = state.pathParameters['cityId'] ?? '';
          return WeatherDetailsScreen(cityId: cityId);
        },
      ),
    ],
    errorBuilder:
        (context, state) => ErrorScreen(error: state.error.toString()),
  );
}
