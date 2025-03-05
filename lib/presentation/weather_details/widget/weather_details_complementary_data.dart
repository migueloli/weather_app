import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/weather_details/widget/weather_info_tile.dart';

class WeatherDetailsComplementaryData extends StatelessWidget {
  const WeatherDetailsComplementaryData({required this.weather, super.key});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            WeatherInfoTile(
              icon: Icons.water_drop,
              label: l10n.weatherHumidity,
              value: '${weather.main.humidity}',
              unit: '%',
              iconColor: Colors.blue,
            ),
            const SizedBox(width: 16),
            WeatherInfoTile(
              icon: Icons.air,
              label: l10n.weatherWindSpeed,
              value: '${weather.wind.speed}',
              unit: 'm/s',
              iconColor: Colors.blueGrey,
            ),
            const SizedBox(width: 16),
            WeatherInfoTile(
              icon: Icons.compress,
              label: l10n.weatherPressure,
              value: '${weather.main.pressure}',
              unit: 'hPa',
              iconColor: Colors.deepPurple,
            ),
            const SizedBox(width: 16),
            WeatherInfoTile(
              icon: Icons.thermostat_auto,
              label: l10n.weatherFeelsLike,
              value: '${weather.main.feelsLike.round()}',
              unit: '°C',
              iconColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Weather>('weather', weather));
  }
}
