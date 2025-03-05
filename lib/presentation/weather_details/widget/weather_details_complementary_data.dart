import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/entity/unity_system.dart';
import 'package:weather_app/data/extensions/unity_system_extension.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:weather_app/presentation/settings/bloc/settings_state.dart';
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
        child: BlocSelector<SettingsBloc, SettingsState, UnitSystem>(
          selector: (state) => state.settings.unitSystem,
          builder: (context, unitSystem) {
            return Row(
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
                  unit: unitSystem.speedUnit,
                  iconColor: Colors.blueGrey,
                ),
                const SizedBox(width: 16),
                WeatherInfoTile(
                  icon: Icons.compress,
                  label: l10n.weatherPressure,
                  value: '${weather.main.pressure}',
                  unit: unitSystem.pressureUnit,
                  iconColor: Colors.deepPurple,
                ),
                const SizedBox(width: 16),
                WeatherInfoTile(
                  icon: Icons.thermostat_auto,
                  label: l10n.weatherFeelsLike,
                  value: '${weather.main.feelsLike.round()}',
                  unit: unitSystem.temperatureUnit,
                  iconColor: Colors.orange,
                ),
              ],
            );
          },
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
