import 'package:weather_app/data/datasources/contracts/city_local_data_source.dart';
import 'package:weather_app/data/entity/city_entity.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/objectbox.g.dart';

class CityLocalDataSourceImpl implements CityLocalDataSource {
  CityLocalDataSourceImpl({required Store store}) {
    _cityBox = Box<CityEntity>(store);
  }

  late final Box<CityEntity> _cityBox;

  @override
  Future<bool> saveCity(City city) async {
    try {
      final coordinatesString = '[${city.lat}, ${city.lon}]';
      final query =
          _cityBox
              .query(CityEntity_.coordinates.equals(coordinatesString))
              .build();

      final existingCity = query.findFirst();
      query.close();

      if (existingCity != null) {
        // City already exists
        return false;
      }

      // Add the city to the database
      final cityEntity = CityEntity.fromCity(city);
      _cityBox.put(cityEntity);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> removeCity(double lat, double lon) async {
    try {
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
    } catch (e) {
      return false;
    }
  }

  @override
  List<City> getAllCities({bool sortByRecent = true}) {
    try {
      final queryBuilder = _cityBox.query();

      if (sortByRecent) {
        queryBuilder.order(
          CityEntity_.savedAtTimestamp,
          flags: Order.descending,
        );
      } else {
        queryBuilder.order(CityEntity_.name);
      }

      final query = queryBuilder.build();
      final results = query.find();
      query.close();

      return results.map((entity) => entity.toCity()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  bool isCitySaved(double lat, double lon) {
    try {
      // Create coordinates string in the same format as in the entity
      final coordinatesString = '[$lat, $lon]';

      final query =
          _cityBox
              .query(CityEntity_.coordinates.equals(coordinatesString))
              .build();

      final exists = query.count() > 0;
      query.close();

      return exists;
    } catch (e) {
      return false;
    }
  }

  @override
  int getCityCount() {
    return _cityBox.count();
  }
}
