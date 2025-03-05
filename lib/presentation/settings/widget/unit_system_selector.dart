import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/data/entity/unity_system.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';

class UnitSystemSelector extends StatelessWidget {
  const UnitSystemSelector({
    required this.currentUnitSystem,
    required this.onUnitSystemChanged,
    super.key,
  });

  final UnitSystem currentUnitSystem;
  final ValueChanged<UnitSystem> onUnitSystemChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        RadioListTile<UnitSystem>(
          title: Text(l10n.metric),
          subtitle: Text('${l10n.temperature}: °C, ${l10n.speed}: m/s'),
          value: UnitSystem.metric,
          groupValue: currentUnitSystem,
          onChanged: (value) {
            if (value != null) {
              onUnitSystemChanged(value);
            }
          },
          selected: currentUnitSystem == UnitSystem.metric,
          dense: true,
        ),
        RadioListTile<UnitSystem>(
          title: Text(l10n.imperial),
          subtitle: Text('${l10n.temperature}: °F, ${l10n.speed}: mph'),
          value: UnitSystem.imperial,
          groupValue: currentUnitSystem,
          onChanged: (value) {
            if (value != null) {
              onUnitSystemChanged(value);
            }
          },
          selected: currentUnitSystem == UnitSystem.imperial,
          dense: true,
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      EnumProperty<UnitSystem>('currentUnitSystem', currentUnitSystem),
    );
    properties.add(
      ObjectFlagProperty<ValueChanged<UnitSystem>>.has(
        'onUnitSystemChanged',
        onUnitSystemChanged,
      ),
    );
  }
}
