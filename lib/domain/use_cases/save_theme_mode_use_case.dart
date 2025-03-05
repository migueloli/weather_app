import 'package:flutter/material.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/domain/repositories/settings_repository_interface.dart';

class SaveThemeModeUseCase {
  const SaveThemeModeUseCase({
    required SettingsRepositoryInterface settingsRepository,
  }) : _settingsRepository = settingsRepository;

  final SettingsRepositoryInterface _settingsRepository;

  Future<Result<bool, AppException>> call(ThemeMode themeMode) async {
    return _settingsRepository.saveThemeMode(themeMode.name);
  }
}
