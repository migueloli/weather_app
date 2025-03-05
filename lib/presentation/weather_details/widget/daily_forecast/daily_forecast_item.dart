import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/weekday_formatter.dart';
import 'package:weather_app/data/models/daily_forecast_data.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';

class DailyForecastItem extends StatelessWidget {
  const DailyForecastItem({
    required this.dailyData,
    required this.isToday,
    super.key,
  });

  final DailyForecastData dailyData;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final formattedDay =
        isToday
            ? AppLocalizations.of(context)!.today
            : WeekdayFormatter.getWeekdayAbreviation(
              context,
              dailyData.date.weekday,
            );

    final weatherCondition = dailyData.weatherCondition;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isToday ? Theme.of(context).primaryColor.withAlpha(25) : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isToday
                  ? Theme.of(context).primaryColor.withAlpha(76)
                  : Colors.grey.withAlpha(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              formattedDay,
              style: TextStyle(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          if (weatherCondition != null)
            Image.network(
              weatherCondition.iconUrl,
              width: 40,
              height: 40,
              errorBuilder:
                  (_, _, _) => const Icon(Icons.cloud_off_outlined, size: 40),
            ),
          Row(
            children: [
              Text(
                '${dailyData.maxTemp.round()}°',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${dailyData.minTemp.round()}°',
                style: TextStyle(color: Colors.grey.shade200),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<DailyForecastData>('dailyData', dailyData),
    );
    properties.add(DiagnosticsProperty<bool>('isToday', isToday));
  }
}
