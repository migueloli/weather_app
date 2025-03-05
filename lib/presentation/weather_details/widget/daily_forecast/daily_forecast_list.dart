import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/data/models/forecast.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/weather_details/widget/daily_forecast/daily_forecast_item.dart';

class DailyForecastList extends StatelessWidget {
  const DailyForecastList({required this.forecast, super.key});

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final today = DateTime.now();
    final dailyData = forecast.getDailyForecast();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: 8,
          ),
          child: Text(
            l10n.dailyForecast,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          color: Theme.of(context).primaryColor.withAlpha(200),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: dailyData.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final data = dailyData[index];
              final isToday =
                  data.date.year == today.year &&
                  data.date.month == today.month &&
                  data.date.day == today.day;

              return DailyForecastItem(dailyData: data, isToday: isToday);
            },
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
