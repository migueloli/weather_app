import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/entity/unity_system.dart';
import 'package:weather_app/domain/repositories/settings_repository.dart';

class SaveUnitSystemUseCase {
  const SaveUnitSystemUseCase({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  final SettingsRepository _settingsRepository;

  Future<Result<bool, AppException>> call(UnitSystem unitSystem) async {
    return _settingsRepository.saveUnitSystem(unitSystem);
  }
}
