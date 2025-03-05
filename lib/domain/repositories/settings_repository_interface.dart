import 'dart:async';

import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/entity/unity_system.dart';
import 'package:weather_app/data/models/app_settings.dart';

abstract class SettingsRepositoryInterface {
  const SettingsRepositoryInterface();

  Stream<AppSettings> get settingsStream;

  Future<Result<AppSettings, AppException>> getSettings();
  Future<Result<bool, AppException>> saveLanguage(String language);
  Future<Result<bool, AppException>> saveUnitSystem(UnitSystem unitSystem);
}
