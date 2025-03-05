import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/extensions/unity_system_extension.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/domain/use_cases/get_saved_cities_use_case.dart';
import 'package:weather_app/domain/use_cases/get_weather_use_case.dart';
import 'package:weather_app/domain/use_cases/remove_saved_city_use_case.dart';
import 'package:weather_app/presentation/home/bloc/home_event.dart';
import 'package:weather_app/presentation/home/bloc/home_state.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetSavedCitiesUseCase getSavedCitiesUseCase,
    required RemoveSavedCityUseCase removeSavedCityUseCase,
    required GetWeatherUseCase getWeatherUseCase,
    required SettingsBloc settingsBloc,
  }) : _getSavedCitiesUseCase = getSavedCitiesUseCase,
       _removeSavedCityUseCase = removeSavedCityUseCase,
       _getWeatherUseCase = getWeatherUseCase,
       _settingsBloc = settingsBloc,
       super(const HomeState()) {
    on<LoadSavedCities>(_onLoadSavedCities);
    on<RemoveSavedCity>(_onRemoveSavedCity);
    on<FetchWeatherForCity>(_onFetchWeatherForCity);
    on<CitiesUpdated>(_onCitiesUpdated);
    on<RefreshAllWeather>(_onRefreshAllWeather);

    _settingsSubscription = _settingsBloc.stream.listen((settingsState) {
      if (state.cities.isNotEmpty) {
        add(const RefreshAllWeather());
      }
    });

    add(const LoadSavedCities());
  }

  final GetSavedCitiesUseCase _getSavedCitiesUseCase;
  final RemoveSavedCityUseCase _removeSavedCityUseCase;
  final GetWeatherUseCase _getWeatherUseCase;
  final SettingsBloc _settingsBloc;
  StreamSubscription<List<City>>? _citiesSubscription;
  StreamSubscription? _settingsSubscription;

  Future<void> _onFetchWeatherForCity(
    FetchWeatherForCity event,
    Emitter<HomeState> emit,
  ) async {
    final cityKey = event.city.coordinates;

    final settings = _settingsBloc.state.settings;
    final units = settings.unitSystem.apiParameter;

    emit(state.copyWith(loadingWeather: {...state.loadingWeather, cityKey}));

    final result = await _getWeatherUseCase(
      lat: event.city.lat,
      lon: event.city.lon,
      units: units,
      lang: settings.language,
    );

    if (result.isFailure) {
      final updatedLoadingWeather = Set<String>.from(state.loadingWeather);
      updatedLoadingWeather.remove(cityKey);

      emit(state.copyWith(loadingWeather: updatedLoadingWeather));
      return;
    }

    final weather = result.value;

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

  Future<void> _onRefreshAllWeather(
    RefreshAllWeather event,
    Emitter<HomeState> emit,
  ) async {
    for (final city in state.cities) {
      add(FetchWeatherForCity(city: city));
    }
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
    _settingsSubscription?.cancel();
    return super.close();
  }
}
