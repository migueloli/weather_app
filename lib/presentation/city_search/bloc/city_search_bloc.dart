import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/domain/use_cases/get_saved_cities_use_case.dart';
import 'package:weather_app/domain/use_cases/remove_saved_city_use_case.dart';
import 'package:weather_app/domain/use_cases/save_city_use_case.dart';
import 'package:weather_app/domain/use_cases/search_cities_use_case.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_event.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_state.dart';

class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {
  CitySearchBloc({
    required SearchCitiesUseCase searchCitiesUseCase,
    required SaveCityUseCase saveCityUseCase,
    required GetSavedCitiesUseCase getSavedCitiesUseCase,
    required RemoveSavedCityUseCase removeSavedCityUseCase,
  }) : _searchCitiesUseCase = searchCitiesUseCase,
       _saveCityUseCase = saveCityUseCase,
       _removeCityUseCase = removeSavedCityUseCase,
       _getSavedCitiesUseCase = getSavedCitiesUseCase,
       super(const CitySearchState()) {
    on<SearchCities>(_onSearchCities, transformer: _debounceSearch);
    on<SaveCity>(_onSaveCity);
    on<RemoveCity>(_onRemoveCity);
    on<CitiesUpdated>(_onCitiesUpdated);
    on<ClearSearch>(_onClearSearch);
    on<LoadSavedCities>(_onLoadSavedCities);

    add(const LoadSavedCities());
  }

  final SearchCitiesUseCase _searchCitiesUseCase;
  final SaveCityUseCase _saveCityUseCase;
  final RemoveSavedCityUseCase _removeCityUseCase;
  final GetSavedCitiesUseCase _getSavedCitiesUseCase;
  final _debounceDuration = const Duration(milliseconds: 500);
  StreamSubscription<List<City>>? _citiesSubscription;

  Future<void> _onSearchCities(
    SearchCities event,
    Emitter<CitySearchState> emit,
  ) async {
    if (_citiesSubscription == null) {
      await _createCitiesStream(emit);
    }

    if (event.query.trim().isEmpty) {
      emit(
        state.copyWith(status: CitySearchStatus.initial, cities: [], query: ''),
      );
      return;
    }

    emit(state.copyWith(status: CitySearchStatus.loading, query: event.query));

    final result = await _searchCitiesUseCase(event.query);
    result.when(
      onSuccess:
          (cities) => emit(
            state.copyWith(
              status: CitySearchStatus.success,
              cities: result.value,
            ),
          ),
      onFailure:
          (error) => emit(
            state.copyWith(
              status: CitySearchStatus.failure,
              error: () => error,
            ),
          ),
    );
  }

  Future<void> _onSaveCity(
    SaveCity event,
    Emitter<CitySearchState> emit,
  ) async {
    final result = await _saveCityUseCase(event.city);
    result.when(onFailure: (error) => emit(state.copyWith(error: () => error)));
  }

  Future<void> _onRemoveCity(
    RemoveCity event,
    Emitter<CitySearchState> emit,
  ) async {
    final result = await _removeCityUseCase(event.city);
    result.when(onFailure: (error) => emit(state.copyWith(error: () => error)));
  }

  void _onCitiesUpdated(CitiesUpdated event, Emitter<CitySearchState> emit) {
    emit(
      state.copyWith(
        savedCities: event.cities.map((city) => city.coordinates).toSet(),
      ),
    );
  }

  void _onClearSearch(ClearSearch event, Emitter<CitySearchState> emit) {
    emit(const CitySearchState());
  }

  void _onLoadSavedCities(
    LoadSavedCities event,
    Emitter<CitySearchState> emit,
  ) => _createCitiesStream(emit);

  Future<void> _createCitiesStream(Emitter<CitySearchState> emit) async {
    await _citiesSubscription?.cancel();
    _citiesSubscription = null;

    _getSavedCitiesUseCase().when(
      onSuccess:
          (citiesStream) =>
              _citiesSubscription = citiesStream.listen((cities) {
                add(CitiesUpdated(cities));
              }),
    );
  }

  Stream<E> _debounceSearch<E>(Stream<E> events, EventMapper<E> mapper) =>
      events.debounce(_debounceDuration).switchMap(mapper);

  @override
  Future<void> close() {
    _citiesSubscription?.cancel();
    return super.close();
  }
}
