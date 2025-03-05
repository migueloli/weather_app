import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/data/models/forecast.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/weather_details/widget/hourly_forecast/hourly_forecast_item.dart';

class HourlyForecastList extends StatelessWidget {
  const HourlyForecastList({required this.forecast, super.key});

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Text(
            l10n.hourlyForecast,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          color: theme.colorScheme.primaryContainer.withAlpha(200),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 132,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              itemCount: forecast.list.length,
              itemBuilder: (context, index) {
                final forecastEntry = forecast.list[index];
                return HourlyForecastItem(forecastEntry: forecastEntry);
              },
              separatorBuilder: (_, _) => const SizedBox(width: 16),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Forecast>('forecast', forecast));
  }
}
