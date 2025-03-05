import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/domain/repositories/settings_repository.dart';

class SaveLanguageUseCase {
  const SaveLanguageUseCase({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  final SettingsRepository _settingsRepository;

  Future<Result<bool, AppException>> call(String language) async {
    return _settingsRepository.saveLanguage(language);
  }
}
