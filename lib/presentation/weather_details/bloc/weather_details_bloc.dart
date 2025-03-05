import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/data/models/forecast.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/domain/use_cases/get_forecast_use_case.dart';
import 'package:weather_app/domain/use_cases/get_weather_use_case.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_event.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_state.dart';

class WeatherDetailsBloc
    extends Bloc<WeatherDetailsEvent, WeatherDetailsState> {
  WeatherDetailsBloc({
    required GetWeatherUseCase getWeatherUseCase,
    required GetForecastUseCase getForecastUseCase,
  }) : _getWeatherUseCase = getWeatherUseCase,
       _getForecastUseCase = getForecastUseCase,
       super(const WeatherDetailsState()) {
    on<LoadWeatherDetails>(_onLoadWeatherDetails);
    on<RefreshWeatherDetails>(_onRefreshWeatherDetails);
  }

  final GetWeatherUseCase _getWeatherUseCase;
  final GetForecastUseCase _getForecastUseCase;
  double? _lastLat;
  double? _lastLon;

  Future<void> _onLoadWeatherDetails(
    LoadWeatherDetails event,
    Emitter<WeatherDetailsState> emit,
  ) async {
    emit(state.copyWith(status: WeatherDetailsStatus.loading));

    _lastLat = event.lat;
    _lastLon = event.lon;

    // Fetch current weather
    final weatherResult = await _getWeatherUseCase(
      lat: event.lat,
      lon: event.lon,
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

    // Fetch forecasts in parallel
    final forecastResult = await _getForecastUseCase(
      lat: event.lat,
      lon: event.lon,
    );

    // We can still show the UI even if forecasts fail
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

    // Fetch all data in parallel
    final results = await Future.wait([
      _getWeatherUseCase(lat: _lastLat!, lon: _lastLon!),
      _getForecastUseCase(lat: _lastLat!, lon: _lastLon!),
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
}
