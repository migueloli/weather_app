import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/extensions/unity_system_extension.dart';
import 'package:weather_app/domain/use_cases/get_weather_use_case.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_event.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_state.dart';

class WeatherDetailsBloc
    extends Bloc<WeatherDetailsEvent, WeatherDetailsState> {
  WeatherDetailsBloc({
    required GetWeatherUseCase getWeatherUseCase,
    required SettingsBloc settingsBloc,
    required double lat,
    required double long,
  }) : _getWeatherUseCase = getWeatherUseCase,
       _settingsBloc = settingsBloc,
       _lat = lat,
       _long = long,
       super(const WeatherDetailsState()) {
    on<LoadWeatherDetails>(_onLoadWeatherDetails);
    on<RefreshWeatherDetails>(_onRefreshWeatherDetails);

    _settingsSubscription = _settingsBloc.stream.listen((settingsState) {
      add(const RefreshWeatherDetails());
    });
  }

  final GetWeatherUseCase _getWeatherUseCase;
  final SettingsBloc _settingsBloc;
  final double _lat;
  final double _long;
  StreamSubscription? _settingsSubscription;

  Future<void> _onLoadWeatherDetails(
    LoadWeatherDetails event,
    Emitter<WeatherDetailsState> emit,
  ) async {
    return _fetchCurrentWeather(emit);
  }

  Future<void> _onRefreshWeatherDetails(
    RefreshWeatherDetails event,
    Emitter<WeatherDetailsState> emit,
  ) async {
    return _fetchCurrentWeather(emit);
  }

  Future<void> _fetchCurrentWeather(Emitter emit) async {
    emit(state.copyWith(status: WeatherDetailsStatus.loading));

    final settings = _settingsBloc.state.settings;

    final weatherResult = await _getWeatherUseCase(
      lat: _lat,
      lon: _long,
      units: settings.unitSystem.apiParameter,
      lang: settings.language,
    );

    emit(
      state.copyWith(
        status:
            weatherResult.isSuccess
                ? WeatherDetailsStatus.success
                : WeatherDetailsStatus.failure,
        weather: weatherResult.isSuccess ? weatherResult.value : null,
        error: () => weatherResult.isFailure ? weatherResult.error : null,
      ),
    );
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }
}
