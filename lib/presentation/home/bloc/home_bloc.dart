import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/domain/use_cases/get_saved_cities_use_case.dart';
import 'package:weather_app/domain/use_cases/get_weather_use_case.dart';
import 'package:weather_app/domain/use_cases/remove_saved_city_use_case.dart';
import 'package:weather_app/presentation/home/bloc/home_event.dart';
import 'package:weather_app/presentation/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetSavedCitiesUseCase getSavedCitiesUseCase,
    required RemoveSavedCityUseCase removeSavedCityUseCase,
    required GetWeatherUseCase getWeatherUseCase,
  }) : _getSavedCitiesUseCase = getSavedCitiesUseCase,
       _removeSavedCityUseCase = removeSavedCityUseCase,
       _getWeatherUseCase = getWeatherUseCase,
       super(const HomeState()) {
    on<LoadSavedCities>(_onLoadSavedCities);
    on<RemoveSavedCity>(_onRemoveSavedCity);
    on<FetchWeatherForCity>(_onFetchWeatherForCity);
    on<CitiesUpdated>(_onCitiesUpdated);

    add(const LoadSavedCities());
  }

  final GetSavedCitiesUseCase _getSavedCitiesUseCase;
  final RemoveSavedCityUseCase _removeSavedCityUseCase;
  final GetWeatherUseCase _getWeatherUseCase;
  StreamSubscription<List<City>>? _citiesSubscription;

  Future<void> _onFetchWeatherForCity(
    FetchWeatherForCity event,
    Emitter<HomeState> emit,
  ) async {
    final cityKey = event.city.coordinates;

    // Mark this city as loading weather
    emit(state.copyWith(loadingWeather: {...state.loadingWeather, cityKey}));

    final result = await _getWeatherUseCase(
      lat: event.city.lat,
      lon: event.city.lon,
    );

    result.when(
      onSuccess: (weather) => _onWeatherFetched(weather, cityKey, emit),
      onFailure: (error) => _onWeatherFetchFailed(cityKey, emit),
    );
  }

  void _onWeatherFetchFailed(String cityKey, Emitter<HomeState> emit) {
    final updatedLoadingWeather = Set<String>.from(state.loadingWeather);
    updatedLoadingWeather.remove(cityKey);

    emit(state.copyWith(loadingWeather: updatedLoadingWeather));
  }

  void _onWeatherFetched(
    Weather weather,
    String cityKey,
    Emitter<HomeState> emit,
  ) {
    final updatedWeatherData = Map<String, Weather>.from(state.weatherData);
    updatedWeatherData[cityKey] = weather;
    final updatedLoadingWeather = Set<String>.from(state.loadingWeather);
    updatedLoadingWeather.remove(cityKey);

    emit(
      state.copyWith(
        weatherData: updatedWeatherData,
        loadingWeather: updatedLoadingWeather,
      ),
    );
  }

  void _onLoadSavedCities(LoadSavedCities event, Emitter<HomeState> emit) =>
      _createCitiesStream(emit);

  Future<void> _createCitiesStream(Emitter<HomeState> emit) async {
    await _citiesSubscription?.cancel();
    _citiesSubscription = null;

    _getSavedCitiesUseCase().when(
      onSuccess:
          (citiesStream) =>
              _citiesSubscription = citiesStream.listen((cities) {
                add(CitiesUpdated(cities));
              }),
      onFailure:
          (error) => emit(
            state.copyWith(status: HomeStatus.failure, error: () => error),
          ),
    );
  }

  Future<void> _onRemoveSavedCity(
    RemoveSavedCity event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _removeSavedCityUseCase(event.city);
    result.when(onFailure: (error) => emit(state.copyWith(error: () => error)));
  }

  void _onCitiesUpdated(CitiesUpdated event, Emitter<HomeState> emit) {
    emit(state.copyWith(status: HomeStatus.success, cities: event.cities));

    for (final city in event.cities) {
      if (!state.weatherData.containsKey(city.coordinates)) {
        add(FetchWeatherForCity(city: city));
      }
    }
  }

  @override
  Future<void> close() {
    _citiesSubscription?.cancel();
    return super.close();
  }
}
