import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/use_cases/get_saved_cities_use_case.dart';
import 'package:weather_app/domain/use_cases/remove_saved_city_use_case.dart';
import 'package:weather_app/presentation/home/bloc/home_event.dart';
import 'package:weather_app/presentation/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetSavedCitiesUseCase getSavedCitiesUseCase,
    required RemoveSavedCityUseCase removeSavedCityUseCase,
  }) : _getSavedCitiesUseCase = getSavedCitiesUseCase,
       _removeSavedCityUseCase = removeSavedCityUseCase,
       super(const HomeState()) {
    on<LoadSavedCities>(_onLoadSavedCities);
    on<RemoveSavedCity>(_onRemoveSavedCity);
    on<CitiesUpdated>(_onCitiesUpdated);
  }

  final GetSavedCitiesUseCase _getSavedCitiesUseCase;
  final RemoveSavedCityUseCase _removeSavedCityUseCase;
  StreamSubscription<List<City>>? _citiesSubscription;

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
      emit(
        state.copyWith(status: HomeStatus.failure, error: () => result.error),
      );
    }
  }

  void _onCitiesUpdated(CitiesUpdated event, Emitter<HomeState> emit) {
    emit(state.copyWith(cities: event.cities));
  }

  @override
  Future<void> close() {
    _citiesSubscription?.cancel();
    return super.close();
  }
}
