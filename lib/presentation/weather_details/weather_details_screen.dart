import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';

class WeatherDetailsScreen extends StatelessWidget {
  const WeatherDetailsScreen({required this.cityId, super.key});
  final String cityId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.weatherDetails)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${l10n.weatherDetails} - $cityId'),
            const SizedBox(height: 16),
            // Placeholder for actual weather data
            Text('${l10n.weatherTemperature}: --°C'),
            Text('${l10n.weatherHumidity}: --%'),
            Text('${l10n.weatherWindSpeed}: -- m/s'),
            Text('${l10n.weatherPressure}: -- hPa'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Refresh action would go here
              },
              child: Text(l10n.actionRefresh),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('cityId', cityId));
  }
}
