import 'package:flutter/material.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/domain/repositories/settings_repository.dart';

class SaveThemeModeUseCase {
  const SaveThemeModeUseCase({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  final SettingsRepository _settingsRepository;

  Future<Result<bool, AppException>> call(ThemeMode themeMode) async {
    return _settingsRepository.saveThemeMode(themeMode.name);
  }
}
