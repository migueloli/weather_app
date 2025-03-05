import 'package:weather_app/data/entity/unity_system.dart';

extension UnitySystemExtension on UnitSystem {
  String get temperatureUnit => this == UnitSystem.metric ? '°C' : '°F';
  String get speedUnit => this == UnitSystem.metric ? 'm/s' : 'mph';
  String get distanceUnit => this == UnitSystem.metric ? 'km' : 'mi';
  String get pressureUnit => this == UnitSystem.metric ? 'hPa' : 'inHg';

  String get apiParameter => this == UnitSystem.metric ? 'metric' : 'imperial';
}
