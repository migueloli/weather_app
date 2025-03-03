import 'package:weather_app/data/datasources/contracts/city_local_data_source.dart';
import 'package:weather_app/data/entity/city_entity.dart';
import 'package:weather_app/objectbox.g.dart';

class CityLocalDataSourceImpl implements CityLocalDataSource {
  CityLocalDataSourceImpl({required Store store}) {
    _cityBox = Box<CityEntity>(store);
  }

  late final Box<CityEntity> _cityBox;

  @override
  Future<bool> saveCity(CityEntity city) async {
    final coordinatesString = '[${city.lat}, ${city.lon}]';
    final query =
        _cityBox
            .query(CityEntity_.coordinates.equals(coordinatesString))
            .build();

    final existingCity = query.findFirst();
    query.close();

    if (existingCity != null) {
      return false;
    }
    _cityBox.put(city);
    return true;
  }

  @override
  Future<bool> removeCity(double lat, double lon) async {
    final coordinatesString = '[$lat, $lon]';

    final query =
        _cityBox
            .query(CityEntity_.coordinates.equals(coordinatesString))
            .build();

    final existingCity = query.findFirst();
    query.close();

    if (existingCity != null) {
      _cityBox.remove(existingCity.id);
      return true;
    }

    return false;
  }

  @override
  List<CityEntity> getAllCities({bool sortByRecent = true}) {
    final query = _getAllCitiesQueryBuilder(sortByRecent: sortByRecent).build();

    final results = query.find();
    query.close();

    return results.toList();
  }

  @override
  bool isCitySaved(double lat, double lon) {
    // Create coordinates string in the same format as in the entity
    final coordinatesString = '[$lat, $lon]';

    final query =
        _cityBox
            .query(CityEntity_.coordinates.equals(coordinatesString))
            .build();

    final exists = query.count() > 0;
    query.close();

    return exists;
  }

  @override
  int getCityCount() {
    return _cityBox.count();
  }

  @override
  Stream<List<CityEntity>> getSavedCitiesStream({bool sortByRecent = true}) {
    return _getAllCitiesQueryBuilder(
      sortByRecent: sortByRecent,
    ).watch(triggerImmediately: true).map((query) => query.find());
  }

  QueryBuilder<CityEntity> _getAllCitiesQueryBuilder({
    bool sortByRecent = true,
  }) {
    final queryBuilder = _cityBox.query();

    if (sortByRecent) {
      queryBuilder.order(CityEntity_.savedAtTimestamp, flags: Order.descending);
    } else {
      queryBuilder.order(CityEntity_.name);
    }
    return queryBuilder;
  }
}
