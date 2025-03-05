import 'dart:async';

import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/datasources/contracts/settings_data_source.dart';
import 'package:weather_app/data/entity/unity_system.dart';
import 'package:weather_app/data/models/app_settings.dart';
import 'package:weather_app/domain/repositories/settings_repository_interface.dart';

class SettingsRepository implements SettingsRepositoryInterface {
  SettingsRepository({required SettingsDataSource settingsDataSource})
    : _settingsDataSource = settingsDataSource {
    updateSettingsStream();
  }

  final SettingsDataSource _settingsDataSource;

  final _settingsController = StreamController<AppSettings>.broadcast();
  @override
  Stream<AppSettings> get settingsStream => _settingsController.stream;

  Future<void> updateSettingsStream() async {
    final settings = await getSettings();
    if (settings.isSuccess) {
      _settingsController.add(settings.value);
    }
  }

  @override
  Future<Result<AppSettings, AppException>> getSettings() async {
    try {
      final language = (await _settingsDataSource.getLanguage()) ?? 'en';
      final unitSystem =
          (await _settingsDataSource.getUnitSystem()) ?? UnitSystem.metric;

      return Result.success(
        AppSettings(language: language, unitSystem: unitSystem),
      );
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }

  @override
  Future<Result<bool, AppException>> saveLanguage(String language) async {
    try {
      await _settingsDataSource.saveLanguage(language);

      unawaited(updateSettingsStream());

      return Result.success(true);
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }

  @override
  Future<Result<bool, AppException>> saveUnitSystem(
    UnitSystem unitSystem,
  ) async {
    try {
      _settingsDataSource.saveUnitSystem(unitSystem);

      unawaited(updateSettingsStream());

      return Result.success(true);
    } on Exception catch (e, st) {
      return Result.failure(ErrorHandler.handleError(e, st));
    }
  }

  void dispose() {
    _settingsController.close();
  }
}
