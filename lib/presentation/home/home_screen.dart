import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.weatherTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.weatherTitle),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/city/search'),
              child: Text(l10n.citySearch),
            ),
          ],
        ),
      ),
    );
  }
}
