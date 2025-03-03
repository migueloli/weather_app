class WeatherCoordinates {
  WeatherCoordinates({required this.lon, required this.lat});

  factory WeatherCoordinates.fromJson(Map<String, dynamic> json) {
    return WeatherCoordinates(
      lon: json['lon'].toDouble(),
      lat: json['lat'].toDouble(),
    );
  }
  final double lon;
  final double lat;

  Map<String, dynamic> toJson() {
    return {'lon': lon, 'lat': lat};
  }

  @override
  String toString() {
    return '[$lon, $lat]';
  }
}
