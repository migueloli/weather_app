import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WeatherDetailsMinMax extends StatelessWidget {
  const WeatherDetailsMinMax({
    required this.icon,
    required this.temp,
    required this.label,
    super.key,
  });

  final IconData icon;
  final String temp;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              temp,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(StringProperty('temp', temp));
    properties.add(StringProperty('label', label));
  }
}
