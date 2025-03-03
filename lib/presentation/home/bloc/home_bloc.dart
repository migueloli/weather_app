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

    if (result.isFailure) {
      final updatedLoadingWeather = Set<String>.from(state.loadingWeather);
      updatedLoadingWeather.remove(cityKey);

      emit(state.copyWith(loadingWeather: updatedLoadingWeather));
      return;
    }

    final weather = result.value;

    // Update the weather data map
    final updatedWeatherData = Map<String, Weather>.from(state.weatherData);
    updatedWeatherData[cityKey] = weather;

    // Remove from loading set
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

    final result = _getSavedCitiesUseCase();
    if (result.isFailure) {
      emit(
        state.copyWith(status: HomeStatus.failure, error: () => result.error),
      );
      return;
    }

    _citiesSubscription = result.value.listen((cities) {
      add(CitiesUpdated(cities));
    });
  }

  Future<void> _onRemoveSavedCity(
    RemoveSavedCity event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _removeSavedCityUseCase(event.city);
    if (result.isFailure) {
      emit(state.copyWith(error: () => result.error));
    }
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
