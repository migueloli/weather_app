import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // Private constructor to prevent instantiation
  EnvConfig._();

  // Initialize the environment variables
  static Future<void> initialize() async {
    await dotenv.load();
  }

  // API related config
  static String get weatherApiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.openweathermap.org/data/3.0';

  static String get weatherApiKey => dotenv.env['API_KEY'] ?? '';
}
