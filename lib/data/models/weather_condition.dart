class WeatherCondition {
  WeatherCondition({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
  final int id;
  final String main;
  final String description;
  final String icon;

  Map<String, dynamic> toJson() {
    return {'id': id, 'main': main, 'description': description, 'icon': icon};
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}
