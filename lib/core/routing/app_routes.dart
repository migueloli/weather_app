part of 'app_router.dart';

abstract class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
  static const String citySearch = '/city-search';
  static const String _weatherDetails = '/weather-details';
  static String weatherDetails(double lat, double long) =>
      '$_weatherDetails?lat=$lat&long=$long';
}
