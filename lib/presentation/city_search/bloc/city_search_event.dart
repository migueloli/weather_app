import 'package:equatable/equatable.dart';

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

class ClearSearch extends CitySearchEvent {}
