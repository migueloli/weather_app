import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';

class ThemeModeSettings extends StatelessWidget {
  const ThemeModeSettings({
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            l10n.themeMode,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        RadioListTile<ThemeMode>(
          title: Text(l10n.themeSystem),
          value: ThemeMode.system,
          groupValue: currentThemeMode,
          onChanged: (value) {
            if (value != null) {
              onThemeModeChanged(value);
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: Text(l10n.themeLight),
          value: ThemeMode.light,
          groupValue: currentThemeMode,
          onChanged: (value) {
            if (value != null) {
              onThemeModeChanged(value);
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: Text(l10n.themeDark),
          value: ThemeMode.dark,
          groupValue: currentThemeMode,
          onChanged: (value) {
            if (value != null) {
              onThemeModeChanged(value);
            }
          },
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      EnumProperty<ThemeMode>('currentThemeMode', currentThemeMode),
    );
    properties.add(
      ObjectFlagProperty<ValueChanged<ThemeMode>>.has(
        'onThemeModeChanged',
        onThemeModeChanged,
      ),
    );
  }
}
