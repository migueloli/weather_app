import 'package:equatable/equatable.dart';
import 'package:weather_app/data/models/city.dart';

abstract class CitySearchEvent extends Equatable {
  const CitySearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchCities extends CitySearchEvent {
  const SearchCities(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class SaveCity extends CitySearchEvent {
  const SaveCity(this.city);

  final City city;

  @override
  List<Object?> get props => [city];
}

class RemoveCity extends CitySearchEvent {
  const RemoveCity(this.city);

  final City city;

  @override
  List<Object?> get props => [city];
}

class CitiesUpdated extends CitySearchEvent {
  const CitiesUpdated(this.cities);

  final List<City> cities;

  @override
  List<Object?> get props => [cities];
}

class ClearSearch extends CitySearchEvent {
  const ClearSearch();
}

class LoadSavedCities extends CitySearchEvent {
  const LoadSavedCities();
}
