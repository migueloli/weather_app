import 'package:objectbox/objectbox.dart';
import 'package:weather_app/data/models/city.dart';

@Entity()
class CityEntity {
  CityEntity({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
    this.id = 0,
    this.state,
    String? coordinates,
    int? savedAtTimestamp,
  }) : coordinates = coordinates ?? '[$lat, $lon]',
       savedAtTimestamp =
           savedAtTimestamp ?? DateTime.now().millisecondsSinceEpoch;

  factory CityEntity.fromCity(City city) {
    return CityEntity(
      name: city.name,
      lat: city.lat,
      lon: city.lon,
      country: city.country,
      state: city.state,
    );
  }

  @Id()
  int id = 0;

  final String name;
  final String coordinates;
  final double lat;
  final double lon;
  final String country;
  final String? state;
  final int savedAtTimestamp;

  City toCity() {
    return City(name: name, lat: lat, lon: lon, country: country, state: state);
  }
}
