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
    on<RefreshSavedCities>(_onRefreshSavedCities);
    on<RemoveSavedCity>(_onRemoveSavedCity);
    on<FetchWeatherForCity>(_onFetchWeatherForCity);
    on<CitiesUpdated>(_onCitiesUpdated);

    _citiesSubscription = _getSavedCitiesUseCase().listen((cities) {
      add(CitiesUpdated(cities));
    });
  }

  final GetSavedCitiesUseCase _getSavedCitiesUseCase;
  final RemoveSavedCityUseCase _removeSavedCityUseCase;
  final GetWeatherUseCase _getWeatherUseCase;
  late StreamSubscription<List<City>> _citiesSubscription;

  Future<void> _onFetchWeatherForCity(
    FetchWeatherForCity event,
    Emitter<HomeState> emit,
  ) async {
    final cityKey = HomeState.getCityKey(event.city.lat, event.city.lon);

    // Mark this city as loading weather
    emit(state.copyWith(loadingWeather: {...state.loadingWeather, cityKey}));

    try {
      final weather = await _getWeatherUseCase(
        lat: event.city.lat,
        lon: event.city.lon,
      );

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
    } catch (e) {
      final updatedLoadingWeather = Set<String>.from(state.loadingWeather);
      updatedLoadingWeather.remove(cityKey);

      emit(state.copyWith(loadingWeather: updatedLoadingWeather));
    }
  }

  void _onRefreshSavedCities(
    RefreshSavedCities event,
    Emitter<HomeState> emit,
  ) {
    _citiesSubscription.cancel();
    _citiesSubscription = _getSavedCitiesUseCase().listen((cities) {
      add(CitiesUpdated(cities));
    });
  }

  Future<void> _onRemoveSavedCity(
    RemoveSavedCity event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _removeSavedCityUseCase(event.city);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to remove city'));
    }
  }

  void _onCitiesUpdated(CitiesUpdated event, Emitter<HomeState> emit) {
    emit(state.copyWith(status: HomeStatus.success, cities: event.cities));

    for (final city in event.cities) {
      if (!state.weatherData.containsKey(
        HomeState.getCityKey(city.lat, city.lon),
      )) {
        add(FetchWeatherForCity(city: city));
      }
    }
  }

  @override
  Future<void> close() {
    _citiesSubscription.cancel();
    return super.close();
  }
}
