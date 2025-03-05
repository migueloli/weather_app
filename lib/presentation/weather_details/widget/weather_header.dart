import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/utils/weekday_formatter.dart';
import 'package:weather_app/data/entity/unity_system.dart';
import 'package:weather_app/data/extensions/unity_system_extension.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:weather_app/presentation/settings/bloc/settings_state.dart';
import 'package:weather_app/presentation/weather_details/widget/weather_details_temperature_item.dart';

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({required this.weather, super.key, this.cityName});

  final Weather weather;
  final String? cityName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final weatherCondition = weather.weather.firstOrNull;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
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
                    (_, _, _) => Icon(
                      Icons.cloud_off_outlined,
                      size: 100,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
              ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimaryContainer.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getWeekdayAndCityName(context),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
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
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  '°C',
                  style: TextStyle(
                    fontSize: 24,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            if (weatherCondition != null) ...[
              const SizedBox(height: 8),
              Text(
                weatherCondition.main,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
            const SizedBox(height: 8),
            BlocSelector<SettingsBloc, SettingsState, UnitSystem>(
              selector: (state) => state.settings.unitSystem,
              builder: (context, unitSystem) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WeatherDetailsTemperatureItem(
                      icon: Icons.arrow_upward,
                      temp:
                          '${weather.main.tempMax.round()}${unitSystem.temperatureUnit}',
                      label: l10n.weatherMax,
                    ),
                    const SizedBox(width: 24),
                    WeatherDetailsTemperatureItem(
                      icon: Icons.arrow_downward,
                      temp:
                          '${weather.main.tempMin.round()}${unitSystem.temperatureUnit}',
                      label: l10n.weatherMin,
                    ),
                  ],
                );
              },
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
