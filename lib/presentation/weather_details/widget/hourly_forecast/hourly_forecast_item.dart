import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/data/models/forecast_entry.dart';

class HourlyForecastItem extends StatelessWidget {
  const HourlyForecastItem({required this.forecastEntry, super.key});

  final ForecastEntry forecastEntry;

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(forecastEntry.dtTxt);
    final timeFormat = DateFormat('HH:mm');
    final formattedTime = timeFormat.format(dateTime);

    final weatherCondition =
        forecastEntry.weather.isNotEmpty ? forecastEntry.weather.first : null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          formattedTime,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        const SizedBox(height: 8),
        if (weatherCondition != null)
          Image.network(
            weatherCondition.iconUrl,
            width: 40,
            height: 40,
            errorBuilder:
                (_, __, ___) => const Icon(Icons.cloud_off_outlined, size: 40),
          ),
        const SizedBox(height: 8),
        Text(
          '${forecastEntry.main.temp.round()}°',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ForecastEntry>('forecastEntry', forecastEntry),
    );
  }
}
