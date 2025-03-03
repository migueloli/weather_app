class WeatherWind {
  WeatherWind({required this.speed, required this.deg, this.gust});

  factory WeatherWind.fromJson(Map<String, dynamic> json) {
    return WeatherWind(
      speed: json['speed'].toDouble(),
      deg: json['deg'],
      gust: json['gust']?.toDouble(),
    );
  }
  final double speed;
  final int deg;
  final double? gust;

  Map<String, dynamic> toJson() {
    return {'speed': speed, 'deg': deg, 'gust': gust};
  }
}
