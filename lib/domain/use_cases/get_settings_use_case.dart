import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/app_settings.dart';
import 'package:weather_app/domain/repositories/settings_repository_interface.dart';

class GetSettingsUseCase {
  const GetSettingsUseCase({
    required SettingsRepositoryInterface settingsRepository,
  }) : _settingsRepository = settingsRepository;

  final SettingsRepositoryInterface _settingsRepository;

  Future<Result<AppSettings, AppException>> call() async {
    return _settingsRepository.getSettings();
  }

  Stream<AppSettings> get settingsStream => _settingsRepository.settingsStream;
}
