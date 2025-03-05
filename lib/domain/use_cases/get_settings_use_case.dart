import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/app_settings.dart';
import 'package:weather_app/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  const GetSettingsUseCase({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  final SettingsRepository _settingsRepository;

  Future<Result<AppSettings, AppException>> call() async {
    return _settingsRepository.getSettings();
  }

  Stream<AppSettings> get settingsStream => _settingsRepository.settingsStream;
}
