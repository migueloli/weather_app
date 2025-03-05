import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/weekday_formatter.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/presentation/weather_details/widget/weather_details_min_max.dart';

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({required this.weather, super.key, this.cityName});

  final Weather weather;
  final String? cityName;

  @override
  Widget build(BuildContext context) {
    final weatherCondition = weather.weather.firstOrNull;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (weatherCondition != null)
              Image.network(
                weatherCondition.iconUrl,
                width: 100,
                height: 100,
                errorBuilder:
                    (_, __, ___) => const Icon(
                      Icons.cloud_off_outlined,
                      size: 100,
                      color: Colors.white,
                    ),
              ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getWeekdayAndCityName(context),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weather.main.temp.round()}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  '°C',
                  style: TextStyle(fontSize: 24, color: Colors.white70),
                ),
              ],
            ),
            if (weatherCondition != null) ...[
              const SizedBox(height: 8),
              Text(
                weatherCondition.main,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WeatherDetailsMinMax(
                  icon: Icons.arrow_upward,
                  temp: '${weather.main.tempMax.round()}°C',
                  label: 'Max',
                ),
                const SizedBox(width: 24),
                WeatherDetailsMinMax(
                  icon: Icons.arrow_downward,
                  temp: '${weather.main.tempMin.round()}°C',
                  label: 'Min',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayAndCityName(BuildContext context) {
    return '${cityName ?? weather.name} - ${WeekdayFormatter.getWeekdayName(context, DateTime.now().weekday)}';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Weather>('weather', weather));
    properties.add(StringProperty('cityName', cityName));
  }
}
