import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/data/datasources/contracts/settings_data_source.dart';
import 'package:weather_app/data/entity/unity_system.dart';

class SettingsDataSourceImpl implements SettingsDataSource {
  SettingsDataSourceImpl({required SharedPreferences sharedPreferences})
    : _prefs = sharedPreferences;

  static const String _languageKey = 'app_language';
  static const String _unitSystemKey = 'unit_system';

  final SharedPreferences _prefs;

  @override
  FutureOr<String?> getLanguage() {
    return _prefs.getString(_languageKey);
  }

  @override
  FutureOr<UnitSystem?> getUnitSystem() {
    final unitSystemIndex = _prefs.getInt(_unitSystemKey);
    return unitSystemIndex != null ? UnitSystem.values[unitSystemIndex] : null;
  }

  @override
  FutureOr<bool> saveLanguage(String language) async {
    return _prefs.setString(_languageKey, language);
  }

  @override
  FutureOr<bool> saveUnitSystem(UnitSystem unitSystem) async {
    return _prefs.setInt(_unitSystemKey, unitSystem.index);
  }
}
