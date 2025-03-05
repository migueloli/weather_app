import 'package:flutter/material.dart';
import 'package:weather_app/data/entity/unity_system.dart';

class AppSettings {
  const AppSettings({
    this.language = 'en',
    this.unitSystem = UnitSystem.metric,
    this.themeMode,
  });

  final String language;
  final UnitSystem unitSystem;
  final String? themeMode;

  AppSettings copyWith({
    String? language,
    UnitSystem? unitSystem,
    ValueGetter<String?>? themeMode,
  }) {
    return AppSettings(
      language: language ?? this.language,
      unitSystem: unitSystem ?? this.unitSystem,
      themeMode: themeMode != null ? themeMode() : this.themeMode,
    );
  }
}
