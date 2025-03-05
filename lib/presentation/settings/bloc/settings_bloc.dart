import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/domain/use_cases/get_settings_use_case.dart';
import 'package:weather_app/domain/use_cases/save_language_use_case.dart';
import 'package:weather_app/domain/use_cases/save_unit_system_use_case.dart';
import 'package:weather_app/presentation/settings/bloc/settings_event.dart';
import 'package:weather_app/presentation/settings/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required GetSettingsUseCase getSettingsUseCase,
    required SaveLanguageUseCase saveLanguageUseCase,
    required SaveUnitSystemUseCase saveUnitSystemUseCase,
  }) : _getSettingsUseCase = getSettingsUseCase,
       _saveLanguageUseCase = saveLanguageUseCase,
       _saveUnitSystemUseCase = saveUnitSystemUseCase,
       super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ChangeUnitSystem>(_onChangeUnitSystem);

    _settingsSubscription = _getSettingsUseCase.settingsStream.listen((
      settings,
    ) {
      add(const LoadSettings());
    });

    // Load settings immediately
    add(const LoadSettings());
  }

  final GetSettingsUseCase _getSettingsUseCase;
  final SaveLanguageUseCase _saveLanguageUseCase;
  final SaveUnitSystemUseCase _saveUnitSystemUseCase;
  late StreamSubscription<dynamic> _settingsSubscription;

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    final result = await _getSettingsUseCase();
    if (result.isFailure) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          error: () => result.error,
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: SettingsStatus.success, settings: result.value),
    );
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    final result = await _saveLanguageUseCase(event.language);
    if (result.isFailure) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          error: () => result.error,
        ),
      );
      return;
    }

    // Settings will be updated via stream subscription
  }

  Future<void> _onChangeUnitSystem(
    ChangeUnitSystem event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    final result = await _saveUnitSystemUseCase(event.unitSystem);
    if (result.isFailure) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          error: () => result.error,
        ),
      );
      return;
    }

    // Settings will be updated via stream subscription
  }

  @override
  Future<void> close() {
    _settingsSubscription.cancel();
    return super.close();
  }
}
