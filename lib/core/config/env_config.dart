import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class EnvConfig {
  const EnvConfig._();

  static Future<void> initialize() => dotenv.load();

  static String get weatherApiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.openweathermap.org/data/2.5';

  static String get weatherApiKey => dotenv.env['API_KEY'] ?? '';
}
