import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/extensions/unity_system_extension.dart';
import 'package:weather_app/domain/use_cases/get_forecast_use_case.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:weather_app/presentation/weather_details/bloc/forecast/weather_forecast_event.dart';
import 'package:weather_app/presentation/weather_details/bloc/forecast/weather_forecast_state.dart';

class WeatherForecastBloc
    extends Bloc<WeatherForecastEvent, WeatherForecastState> {
  WeatherForecastBloc({
    required GetForecastUseCase getForecastUseCase,
    required SettingsBloc settingsBloc,
    required double lat,
    required double long,
  }) : _getForecastUseCase = getForecastUseCase,
       _settingsBloc = settingsBloc,
       _lat = lat,
       _long = long,
       super(const WeatherForecastState()) {
    on<LoadWeatherForecast>(_onLoadWeatherForecast);
    on<RefreshWeatherForecast>(_onRefreshWeatherForecast);

    _settingsSubscription = _settingsBloc.stream.listen((settingsState) {
      add(const RefreshWeatherForecast());
    });
  }

  final GetForecastUseCase _getForecastUseCase;
  final SettingsBloc _settingsBloc;
  final double _lat;
  final double _long;
  StreamSubscription? _settingsSubscription;

  Future<void> _onLoadWeatherForecast(
    LoadWeatherForecast event,
    Emitter<WeatherForecastState> emit,
  ) async {
    return _fetchForecast(emit);
  }

  Future<void> _onRefreshWeatherForecast(
    RefreshWeatherForecast event,
    Emitter<WeatherForecastState> emit,
  ) async {
    return _fetchForecast(emit);
  }

  Future<void> _fetchForecast(Emitter emit) async {
    emit(state.copyWith(status: WeatherForecastStatus.loading));

    final settings = _settingsBloc.state.settings;

    final forecastResult = await _getForecastUseCase(
      lat: _lat,
      lon: _long,
      units: settings.unitSystem.apiParameter,
      lang: settings.language,
    );

    emit(
      state.copyWith(
        status:
            forecastResult.isSuccess
                ? WeatherForecastStatus.success
                : WeatherForecastStatus.failure,
        forecast: forecastResult.isSuccess ? forecastResult.value : null,
        error: () => (forecastResult.isFailure ? forecastResult.error : null),
      ),
    );
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }
}
