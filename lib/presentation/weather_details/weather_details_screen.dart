import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WeatherDetailsScreen extends StatelessWidget {
  const WeatherDetailsScreen({
    required this.lat,
    required this.long,
    super.key,
  });

  final double lat;
  final double long;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Details')),
      body: Center(child: Text('Weather Details: [$lat, $long]')),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('lat', lat));
    properties.add(DoubleProperty('long', long));
  }
}
