class WeatherClouds {
  WeatherClouds({required this.all});

  factory WeatherClouds.fromJson(Map<String, dynamic> json) {
    return WeatherClouds(all: json['all']);
  }
  final int all;

  Map<String, dynamic> toJson() {
    return {'all': all};
  }
}
