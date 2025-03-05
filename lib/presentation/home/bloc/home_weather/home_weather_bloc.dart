import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/extensions/unity_system_extension.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/use_cases/get_weather_use_case.dart';
import 'package:weather_app/presentation/home/bloc/home_weather/home_weather_event.dart';
import 'package:weather_app/presentation/home/bloc/home_weather/home_weather_state.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';

class HomeWeatherBloc extends Bloc<HomeWeatherEvent, HomeWeatherState> {
  HomeWeatherBloc({
    required GetWeatherUseCase getWeatherUseCase,
    required SettingsBloc settingsBloc,
    required City city,
  }) : _getWeatherUseCase = getWeatherUseCase,
       _settingsBloc = settingsBloc,
       _city = city,
       super(const HomeWeatherState()) {
    on<LoadHomeWeather>(_onLoadHomeWeather);
    on<RefreshHomeWeather>(_onRefreshHomeWeather);

    _settingsSubscription = _settingsBloc.stream.listen((settingsState) {
      add(const RefreshHomeWeather());
    });
  }

  final GetWeatherUseCase _getWeatherUseCase;
  final SettingsBloc _settingsBloc;
  final City _city;

  StreamSubscription? _settingsSubscription;

  Future<void> _onLoadHomeWeather(
    LoadHomeWeather event,
    Emitter<HomeWeatherState> emit,
  ) async {
    return _fetchWeather(emit);
  }

  Future<void> _onRefreshHomeWeather(
    RefreshHomeWeather event,
    Emitter<HomeWeatherState> emit,
  ) async {
    return _fetchWeather(emit);
  }

  Future<void> _fetchWeather(Emitter<HomeWeatherState> emit) async {
    emit(state.copyWith(status: HomeWeatherStatus.loading));

    final settings = _settingsBloc.state.settings;
    final units = settings.unitSystem.apiParameter;

    final result = await _getWeatherUseCase(
      lat: _city.lat,
      lon: _city.lon,
      units: units,
      lang: settings.language,
    );

    emit(
      state.copyWith(
        status:
            result.isSuccess
                ? HomeWeatherStatus.success
                : HomeWeatherStatus.failure,
        weather: result.isSuccess ? result.value : null,
        error: () => result.isFailure ? result.error : null,
      ),
    );
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }
}
