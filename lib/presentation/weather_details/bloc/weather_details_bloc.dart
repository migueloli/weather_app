import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/extensions/unity_system_extension.dart';
import 'package:weather_app/data/models/forecast.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/domain/use_cases/get_forecast_use_case.dart';
import 'package:weather_app/domain/use_cases/get_weather_use_case.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_event.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_state.dart';

class WeatherDetailsBloc
    extends Bloc<WeatherDetailsEvent, WeatherDetailsState> {
  WeatherDetailsBloc({
    required GetWeatherUseCase getWeatherUseCase,
    required GetForecastUseCase getForecastUseCase,
    required SettingsBloc settingsBloc,
  }) : _getWeatherUseCase = getWeatherUseCase,
       _getForecastUseCase = getForecastUseCase,
       _settingsBloc = settingsBloc,
       super(const WeatherDetailsState()) {
    on<LoadWeatherDetails>(_onLoadWeatherDetails);
    on<RefreshWeatherDetails>(_onRefreshWeatherDetails);

    _settingsSubscription = _settingsBloc.stream.listen((settingsState) {
      if (_lastLat != null && _lastLon != null) {
        add(const RefreshWeatherDetails());
      }
    });
  }

  final GetWeatherUseCase _getWeatherUseCase;
  final GetForecastUseCase _getForecastUseCase;
  final SettingsBloc _settingsBloc;
  StreamSubscription? _settingsSubscription;
  double? _lastLat;
  double? _lastLon;

  Future<void> _onLoadWeatherDetails(
    LoadWeatherDetails event,
    Emitter<WeatherDetailsState> emit,
  ) async {
    emit(state.copyWith(status: WeatherDetailsStatus.loading));

    _lastLat = event.lat;
    _lastLon = event.lon;

    final settings = _settingsBloc.state.settings;

    final weatherResult = await _getWeatherUseCase(
      lat: event.lat,
      lon: event.lon,
      units: settings.unitSystem.apiParameter,
      lang: settings.language,
    );

    if (weatherResult.isFailure) {
      emit(
        state.copyWith(
          status: WeatherDetailsStatus.failure,
          error: () => weatherResult.error,
        ),
      );
      return;
    }

    final forecastResult = await _getForecastUseCase(
      lat: event.lat,
      lon: event.lon,
      units: settings.unitSystem.apiParameter,
      lang: settings.language,
    );

    emit(
      state.copyWith(
        status: WeatherDetailsStatus.success,
        weather: weatherResult.value,
        forecast: forecastResult.isSuccess ? forecastResult.value : null,
      ),
    );
  }

  Future<void> _onRefreshWeatherDetails(
    RefreshWeatherDetails event,
    Emitter<WeatherDetailsState> emit,
  ) async {
    if (_lastLat == null || _lastLon == null) return;

    emit(state.copyWith(status: WeatherDetailsStatus.loading));

    final settings = _settingsBloc.state.settings;

    final results = await Future.wait([
      _getWeatherUseCase(
        lat: _lastLat!,
        lon: _lastLon!,
        units: settings.unitSystem.apiParameter,
        lang: settings.language,
      ),
      _getForecastUseCase(
        lat: _lastLat!,
        lon: _lastLon!,
        units: settings.unitSystem.apiParameter,
        lang: settings.language,
      ),
    ]);

    final weatherResult = results[0] as Result<Weather, AppException>;
    final forecastResult = results[1] as Result<Forecast, AppException>;

    if (weatherResult.isFailure) {
      emit(
        state.copyWith(
          status: WeatherDetailsStatus.failure,
          error: () => weatherResult.error,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: WeatherDetailsStatus.success,
        weather: weatherResult.value,
        forecast:
            forecastResult.isSuccess ? forecastResult.value : state.forecast,
      ),
    );
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }
}
