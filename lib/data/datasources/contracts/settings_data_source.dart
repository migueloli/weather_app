import 'dart:async';

import 'package:weather_app/data/entity/unity_system.dart';

abstract class SettingsDataSource {
  FutureOr<String?> getLanguage();
  FutureOr<UnitSystem?> getUnitSystem();
  FutureOr<bool> saveLanguage(String language);
  FutureOr<bool> saveUnitSystem(UnitSystem unitSystem);
}
