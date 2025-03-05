import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/data/entity/unity_system.dart';
import 'package:weather_app/data/extensions/unity_system_extension.dart';
import 'package:weather_app/data/models/forecast_entry.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:weather_app/presentation/settings/bloc/settings_state.dart';

class HourlyForecastItem extends StatelessWidget {
  const HourlyForecastItem({required this.forecastEntry, super.key});

  final ForecastEntry forecastEntry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final dateTime = DateTime.parse(forecastEntry.dtTxt);
    final timeFormat = DateFormat('HH:mm');
    final formattedTime = timeFormat.format(dateTime);

    final weatherCondition = forecastEntry.weather.firstOrNull;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          formattedTime,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
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
        BlocSelector<SettingsBloc, SettingsState, UnitSystem>(
          selector: (state) => state.settings.unitSystem,
          builder: (context, unitSystem) {
            return Text(
              '${forecastEntry.main.temp.round()}${unitSystem.temperatureUnit}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            );
          },
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
