import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/extensions/theme_mode_extension.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/common/widgets/error_view.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:weather_app/presentation/settings/bloc/settings_event.dart';
import 'package:weather_app/presentation/settings/bloc/settings_state.dart';
import 'package:weather_app/presentation/settings/widget/language_selector.dart';
import 'package:weather_app/presentation/settings/widget/theme_mode_settings.dart';
import 'package:weather_app/presentation/settings/widget/unit_system_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state.status == SettingsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SettingsStatus.failure) {
            return ErrorView(
              error: state.error,
              onRetry: () {
                context.read<SettingsBloc>().add(const LoadSettings());
              },
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.language,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LanguageSelector(
                        currentLanguage: state.settings.language,
                        onLanguageChanged: (language) {
                          context.read<SettingsBloc>().add(
                            ChangeLanguage(language),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.unitSystem,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      UnitSystemSelector(
                        currentUnitSystem: state.settings.unitSystem,
                        onUnitSystemChanged: (unitSystem) {
                          context.read<SettingsBloc>().add(
                            ChangeUnitSystem(unitSystem),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.unitSystem,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ThemeModeSettings(
                        currentThemeMode: ThemeMode.values.byNameWithDefault(
                          state.settings.themeMode,
                        ),
                        onThemeModeChanged: (themeMode) {
                          context.read<SettingsBloc>().add(
                            ChangeThemeMode(themeMode),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
