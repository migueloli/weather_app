import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/data/entity/unity_system.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class ChangeLanguage extends SettingsEvent {
  const ChangeLanguage(this.language);

  final String language;

  @override
  List<Object?> get props => [language];
}

class ChangeUnitSystem extends SettingsEvent {
  const ChangeUnitSystem(this.unitSystem);

  final UnitSystem unitSystem;

  @override
  List<Object?> get props => [unitSystem];
}

class ChangeThemeMode extends SettingsEvent {
  const ChangeThemeMode(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}
