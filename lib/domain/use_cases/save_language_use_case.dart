import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/domain/repositories/settings_repository_interface.dart';

class SaveLanguageUseCase {
  const SaveLanguageUseCase({
    required SettingsRepositoryInterface settingsRepository,
  }) : _settingsRepository = settingsRepository;

  final SettingsRepositoryInterface _settingsRepository;

  Future<Result<bool, AppException>> call(String language) async {
    return _settingsRepository.saveLanguage(language);
  }
}
