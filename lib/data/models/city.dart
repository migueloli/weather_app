import 'package:equatable/equatable.dart';
import 'package:weather_app/core/utils/json_types.dart';

class City extends Equatable {
  const City({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    this.state,
    this.localNames = const {},
  });

  factory City.fromJson(JsonObject json) {
    return City(
      name: json['name'] as String,
      lat: json['lat'] as double,
      lon: json['lon'] as double,
      country: json['country'] as String,
      state: json['state'] as String?,
      localNames:
          json['local_names'] != null
              ? Map<String, String>.from(json['local_names'] as Map)
              : const {},
    );
  }

  final String name;
  final double lat;
  final double lon;
  final String country;
  final String? state;
  final Map<String, String> localNames;

  String get coordinates => '[$lat,$lon]';

  String get displayName {
    final buffer = StringBuffer(name);
    if (state != null && state!.isNotEmpty) {
      buffer.write(', $state');
    }
    buffer.write(', $country');
    return buffer.toString();
  }

  String getLocalDisplayName(String localeCode) {
    final buffer = StringBuffer(getLocalName(localeCode));
    if (state != null && state!.isNotEmpty) {
      buffer.write(', $state');
    }
    buffer.write(', $country');
    return buffer.toString();
  }

  String getLocalName(String localeCode) => localNames[localeCode] ?? name;

  JsonObject toJson() {
    return {
      'name': name,
      'lat': lat,
      'lon': lon,
      'country': country,
      'state': state,
      'local_names': localNames,
    };
  }

  @override
  List<Object?> get props => [name, lat, lon, country, state];

  @override
  String toString() => displayName;
}
