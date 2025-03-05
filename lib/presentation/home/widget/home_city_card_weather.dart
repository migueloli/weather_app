import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/entity/unity_system.dart';
import 'package:weather_app/data/extensions/unity_system_extension.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/common/widgets/empty_state.dart';
import 'package:weather_app/presentation/common/widgets/error_view.dart';
import 'package:weather_app/presentation/home/bloc/home_weather/home_weather_bloc.dart';
import 'package:weather_app/presentation/home/bloc/home_weather/home_weather_event.dart';
import 'package:weather_app/presentation/home/bloc/home_weather/home_weather_state.dart';
import 'package:weather_app/presentation/home/widget/loading/home_city_card_weather_loading.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:weather_app/presentation/settings/bloc/settings_state.dart';

class HomeCityCardWeather extends StatelessWidget {
  const HomeCityCardWeather({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocBuilder<HomeWeatherBloc, HomeWeatherState>(
      builder: (context, state) {
        if (state.status == HomeWeatherStatus.loading) {
          return const HomeCityCardWeatherLoading();
        }

        if (state.status == HomeWeatherStatus.failure) {
          return ErrorView(
            isSmall: true,
            error: state.error,
            onRetry:
                () => context.read<HomeWeatherBloc>().add(
                  const RefreshHomeWeather(),
                ),
          );
        }

        final weather = state.weather;
        if (weather == null) {
          return EmptyState(
            isSmall: true,
            title: l10n.weatherDataUnavailable,
            icon: Icons.cloud_off,
            action: ElevatedButton(
              onPressed:
                  () => context.read<HomeWeatherBloc>().add(
                    const RefreshHomeWeather(),
                  ),
              child: Text(l10n.actionRetry),
            ),
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (weather.weather.isNotEmpty) ...[
              Image.network(
                weather.weather.first.iconUrl,
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
                        '${weather.main.temp.round()}${unitSystem.temperatureUnit}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        weather.weather.isNotEmpty
                            ? weather.weather.first.main
                            : '',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.water_drop, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${weather.main.humidity}%',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.air, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${weather.wind.speed} ${unitSystem.speedUnit}',
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
      },
    );
  }
}
