import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/utils/weekday_formatter.dart';
import 'package:weather_app/data/entity/unity_system.dart';
import 'package:weather_app/data/extensions/unity_system_extension.dart';
import 'package:weather_app/data/models/daily_forecast_data.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:weather_app/presentation/settings/bloc/settings_state.dart';

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
    final theme = Theme.of(context);

    final formattedDay =
        isToday
            ? AppLocalizations.of(context)!.today
            : WeekdayFormatter.getWeekdayAbreviation(
              context,
              dailyData.date.weekday,
            );

    final weatherCondition = dailyData.weatherCondition;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              formattedDay,
              style: TextStyle(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: theme.colorScheme.onPrimaryContainer,
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
          BlocSelector<SettingsBloc, SettingsState, UnitSystem>(
            selector: (state) => state.settings.unitSystem,
            builder: (context, unitSystem) {
              return Row(
                children: [
                  Text(
                    '${dailyData.maxTemp.round()}${unitSystem.temperatureUnit}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${dailyData.minTemp.round()}${unitSystem.temperatureUnit}',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              );
            },
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
