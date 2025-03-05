import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/entity/unity_system.dart';
import 'package:weather_app/data/extensions/unity_system_extension.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/home/widget/loading/home_city_card_weather_loading.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:weather_app/presentation/settings/bloc/settings_state.dart';

class HomeCityCardWeather extends StatelessWidget {
  const HomeCityCardWeather({required this.isLoading, super.key, this.weather});

  final Weather? weather;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (isLoading) {
      return const HomeCityCardWeatherLoading();
    }

    if (weather == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            l10n.weatherDataUnavailable,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (weather!.weather.isNotEmpty) ...[
          Image.network(
            weather!.weather.first.iconUrl,
            width: 64,
            height: 64,
            errorBuilder: (_, _, _) => const Icon(Icons.wb_sunny, size: 48),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: BlocSelector<SettingsBloc, SettingsState, UnitSystem>(
            selector: (state) => state.settings.unitSystem,
            builder: (context, unitSystem) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather!.main.temp.round()}${unitSystem.temperatureUnit}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    weather!.weather.isNotEmpty
                        ? weather!.weather.first.main
                        : '',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.water_drop, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${weather!.main.humidity}%',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.air, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${weather!.wind.speed} ${unitSystem.speedUnit}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Weather?>('weather', weather));
    properties.add(DiagnosticsProperty<bool>('isLoading', isLoading));
  }
}
