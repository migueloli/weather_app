import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/domain/use_cases/manage_saved_cities_use_case.dart';
import 'package:weather_app/presentation/common/blocs/city_save_event.dart';
import 'package:weather_app/presentation/common/blocs/city_save_state.dart';

class CitySaveBloc extends Bloc<CitySaveEvent, CitySaveState> {
  CitySaveBloc({required ManageSavedCitiesUseCase manageSavedCitiesUseCase})
    : _manageSavedCitiesUseCase = manageSavedCitiesUseCase,
      super(const CitySaveState()) {
    on<LoadSavedCities>(_onLoadSavedCities);
    on<AddCity>(_onAddCity);
    on<RemoveCity>(_onRemoveCity);
    on<CheckCitySaved>(_onCheckCitySaved);
  }

  final ManageSavedCitiesUseCase _manageSavedCitiesUseCase;

  void _onLoadSavedCities(LoadSavedCities event, Emitter<CitySaveState> emit) {
    emit(state.copyWith(status: CitySaveStatus.loading));

    try {
      final cities = _manageSavedCitiesUseCase.getSavedCities();
      emit(state.copyWith(status: CitySaveStatus.success, cities: cities));
    } catch (e) {
      emit(
        state.copyWith(
          status: CitySaveStatus.failure,
          errorMessage: 'Failed to load saved cities',
        ),
      );
    }
  }

  Future<void> _onAddCity(AddCity event, Emitter<CitySaveState> emit) async {
    try {
      final success = await _manageSavedCitiesUseCase.saveCity(event.city);

      if (success) {
        // Reload cities after adding
        final cities = _manageSavedCitiesUseCase.getSavedCities();
        emit(state.copyWith(cities: cities, isCurrentCitySaved: true));
      }
    } catch (e) {
      // Don't change state on error, just keep current state
    }
  }

  Future<void> _onRemoveCity(
    RemoveCity event,
    Emitter<CitySaveState> emit,
  ) async {
    try {
      final success = await _manageSavedCitiesUseCase.removeCity(
        event.lat,
        event.lon,
      );

      if (success) {
        // Reload cities after removing
        final cities = _manageSavedCitiesUseCase.getSavedCities();

        // Check if this affects current city saved status
        final isCurrentCityRemoved =
            state.isCurrentCitySaved &&
            cities.every(
              (city) => city.lat != event.lat || city.lon != event.lon,
            );

        emit(
          state.copyWith(
            cities: cities,
            isCurrentCitySaved:
                isCurrentCityRemoved ? false : state.isCurrentCitySaved,
          ),
        );
      }
    } catch (e) {
      // Don't change state on error, just keep current state
    }
  }

  void _onCheckCitySaved(CheckCitySaved event, Emitter<CitySaveState> emit) {
    final isSaved = _manageSavedCitiesUseCase.isCitySaved(event.lat, event.lon);
    emit(state.copyWith(isCurrentCitySaved: isSaved));
  }
}
