import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/domain/use_cases/get_settings_use_case.dart';
import 'package:weather_app/domain/use_cases/save_language_use_case.dart';
import 'package:weather_app/domain/use_cases/save_theme_mode_use_case.dart';
import 'package:weather_app/domain/use_cases/save_unit_system_use_case.dart';
import 'package:weather_app/presentation/settings/bloc/settings_event.dart';
import 'package:weather_app/presentation/settings/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required GetSettingsUseCase getSettingsUseCase,
    required SaveLanguageUseCase saveLanguageUseCase,
    required SaveUnitSystemUseCase saveUnitSystemUseCase,
    required SaveThemeModeUseCase saveThemeModeUseCase,
  }) : _getSettingsUseCase = getSettingsUseCase,
       _saveLanguageUseCase = saveLanguageUseCase,
       _saveUnitSystemUseCase = saveUnitSystemUseCase,
       _saveThemeModeUseCase = saveThemeModeUseCase,
       super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeLanguage>(_onSaveLanguage);
    on<ChangeUnitSystem>(_onSaveUnitSystem);
    on<ChangeThemeMode>(_onSaveThemeMode);
  }

  final GetSettingsUseCase _getSettingsUseCase;
  final SaveLanguageUseCase _saveLanguageUseCase;
  final SaveUnitSystemUseCase _saveUnitSystemUseCase;
  final SaveThemeModeUseCase _saveThemeModeUseCase;

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    final result = await _getSettingsUseCase();

    emit(
      state.copyWith(
        status:
            result.isSuccess ? SettingsStatus.success : SettingsStatus.failure,
        error: result.isFailure ? () => result.error : null,
        settings: result.isSuccess ? result.value : null,
      ),
    );
  }

  Future<void> _onSaveLanguage(
    ChangeLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    final result = await _saveLanguageUseCase(event.language);

    emit(
      state.copyWith(
        status:
            result.isSuccess ? SettingsStatus.success : SettingsStatus.failure,
        error: result.isFailure ? () => result.error : null,
        settings:
            result.isSuccess
                ? state.settings.copyWith(language: event.language)
                : null,
      ),
    );
  }

  Future<void> _onSaveUnitSystem(
    ChangeUnitSystem event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    final result = await _saveUnitSystemUseCase(event.unitSystem);

    emit(
      state.copyWith(
        status:
            result.isSuccess ? SettingsStatus.success : SettingsStatus.failure,
        error: result.isFailure ? () => result.error : null,
        settings:
            result.isSuccess
                ? state.settings.copyWith(unitSystem: event.unitSystem)
                : null,
      ),
    );
  }

  Future<void> _onSaveThemeMode(
    ChangeThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    final result = await _saveThemeModeUseCase(event.themeMode);

    emit(
      state.copyWith(
        status:
            result.isSuccess ? SettingsStatus.success : SettingsStatus.failure,
        error: result.isFailure ? () => result.error : null,
        settings:
            result.isSuccess
                ? state.settings.copyWith(themeMode: () => event.themeMode.name)
                : null,
      ),
    );
  }
}
