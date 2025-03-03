import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class EnvConfig {
  EnvConfig._();

  static Future<void> initialize() async {
    await dotenv.load();
  }

  static String get weatherApiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.openweathermap.org/data/3.0';

  static String get weatherApiKey => dotenv.env['API_KEY'] ?? '';
}
