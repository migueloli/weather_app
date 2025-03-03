import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/exception/api_exception.dart';
import 'package:weather_app/core/exception/network_exception.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/use_cases/get_weather_use_case.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_event.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({required GetWeatherUseCase getWeatherUseCase})
    : _getWeatherUseCase = getWeatherUseCase,
      super(const WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
    on<ResetWeather>(_onResetWeather);
  }

  final GetWeatherUseCase _getWeatherUseCase;

  Future<void> _onFetchWeather(
    FetchWeather event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());

    try {
      final weather = await _getWeatherUseCase.execute(
        lat: event.lat,
        lon: event.lon,
        units: event.units,
        lang: event.lang,
      );

      // Create a City object based on the weather data
      final city = City(
        name: weather.name,
        lat: weather.coord.lat,
        lon: weather.coord.lon,
        country: weather.sys.country,
      );

      final lastUpdatedTimestamp = _getWeatherUseCase.getLastUpdatedTimestamp(
        event.lat,
        event.lon,
      );

      final lastUpdated =
          lastUpdatedTimestamp != null
              ? DateTime.fromMillisecondsSinceEpoch(lastUpdatedTimestamp)
              : null;

      emit(WeatherLoaded(weather, city: city, lastUpdated: lastUpdated));
    } on NetworkException catch (e) {
      emit(WeatherError(errorMessage: e.toString()));
    } on ApiException catch (e) {
      emit(WeatherError(errorMessage: e.message));
    } catch (e) {
      emit(WeatherError(errorMessage: e.toString()));
    }
  }

  void _onResetWeather(ResetWeather event, Emitter<WeatherState> emit) {
    emit(const WeatherInitial());
  }
}
