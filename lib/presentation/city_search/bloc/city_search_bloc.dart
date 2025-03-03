import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:weather_app/core/exception/api_exception.dart';
import 'package:weather_app/core/exception/app_exception.dart';
import 'package:weather_app/core/exception/app_exception_type.dart';
import 'package:weather_app/domain/use_cases/search_cities_use_case.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_event.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_state.dart';

class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {
  CitySearchBloc({required SearchCitiesUseCase searchCitiesUseCase})
    : _searchCitiesUseCase = searchCitiesUseCase,
      super(const CitySearchState()) {
    on<SearchCities>(_onSearchCities, transformer: _debounceSearch);
    on<ClearSearch>(_onClearSearch);
  }

  final SearchCitiesUseCase _searchCitiesUseCase;
  final _debounceDuration = const Duration(milliseconds: 500);

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
      final cities = await _searchCitiesUseCase.execute(event.query);
      emit(state.copyWith(status: CitySearchStatus.success, cities: cities));
    } on AppException catch (e) {
      emit(state.copyWith(status: CitySearchStatus.failure, error: e));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: CitySearchStatus.failure,
          error: ApiException(
            statusCode: -1,
            message: e.toString(),
            type: AppExceptionType.unknown,
          ),
        ),
      );
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<CitySearchState> emit) {
    emit(const CitySearchState());
  }

  Stream<E> _debounceSearch<E>(Stream<E> events, EventMapper<E> mapper) =>
      events.debounce(_debounceDuration).switchMap(mapper);
}
