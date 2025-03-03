import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:weather_app/core/exception/api_exception.dart';
import 'package:weather_app/core/exception/app_exception.dart';
import 'package:weather_app/core/exception/app_exception_type.dart';
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

    _citiesSubscription = _getSavedCitiesUseCase().listen((cities) {
      add(CitiesUpdated(cities));
    });
  }

  final SearchCitiesUseCase _searchCitiesUseCase;
  final SaveCityUseCase _saveCityUseCase;
  final RemoveSavedCityUseCase _removeCityUseCase;
  final GetSavedCitiesUseCase _getSavedCitiesUseCase;
  final _debounceDuration = const Duration(milliseconds: 500);
  late StreamSubscription<List<City>> _citiesSubscription;

  Future<void> _onSearchCities(
    SearchCities event,
    Emitter<CitySearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(
        state.copyWith(status: CitySearchStatus.initial, cities: [], query: ''),
      );
      return;
    }

    emit(state.copyWith(status: CitySearchStatus.loading, query: event.query));

    try {
      final cities = await _searchCitiesUseCase(event.query);
      emit(state.copyWith(status: CitySearchStatus.success, cities: cities));
    } on AppException catch (e) {
      emit(state.copyWith(status: CitySearchStatus.failure, error: () => e));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: CitySearchStatus.failure,
          error:
              () => ApiException(
                statusCode: -1,
                message: e.toString(),
                type: AppExceptionType.unknown,
              ),
        ),
      );
    }
  }

  void _onSaveCity(SaveCity event, Emitter<CitySearchState> emit) {
    _saveCityUseCase(event.city);
  }

  void _onRemoveCity(RemoveCity event, Emitter<CitySearchState> emit) {
    _removeCityUseCase(event.city);
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

  Stream<E> _debounceSearch<E>(Stream<E> events, EventMapper<E> mapper) =>
      events.debounce(_debounceDuration).switchMap(mapper);

  @override
  Future<void> close() {
    _citiesSubscription.cancel();
    return super.close();
  }
}
