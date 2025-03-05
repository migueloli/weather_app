import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WeatherInfoTile extends StatelessWidget {
  const WeatherInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? unit;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 32,
          color: iconColor ?? Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 16),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            text: value,
            children:
                unit != null
                    ? [
                      TextSpan(
                        text: ' $unit',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ]
                    : null,
          ),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(StringProperty('label', label));
    properties.add(StringProperty('value', value));
    properties.add(StringProperty('unit', unit));
    properties.add(ColorProperty('iconColor', iconColor));
  }
}
