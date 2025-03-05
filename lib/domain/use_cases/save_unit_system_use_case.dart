import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/entity/unity_system.dart';
import 'package:weather_app/domain/repositories/settings_repository_interface.dart';

class SaveUnitSystemUseCase {
  const SaveUnitSystemUseCase({
    required SettingsRepositoryInterface settingsRepository,
  }) : _settingsRepository = settingsRepository;

  final SettingsRepositoryInterface _settingsRepository;

  Future<Result<bool, AppException>> call(UnitSystem unitSystem) async {
    return _settingsRepository.saveUnitSystem(unitSystem);
  }
}
