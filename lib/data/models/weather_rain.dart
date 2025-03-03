class WeatherRain {
  WeatherRain({this.oneHour, this.threeHours});

  factory WeatherRain.fromJson(Map<String, dynamic> json) {
    return WeatherRain(
      oneHour: json['1h']?.toDouble(),
      threeHours: json['3h']?.toDouble(),
    );
  }
  final double? oneHour;
  final double? threeHours;

  Map<String, dynamic> toJson() {
    return {'1h': oneHour, '3h': threeHours};
  }
}
