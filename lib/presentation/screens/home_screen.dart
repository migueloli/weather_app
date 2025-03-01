import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

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
              onPressed: () => context.go('/weather/sample-city-id'),
              child: Text(l10n.weatherDetails),
            ),
          ],
        ),
      ),
    );
  }
}
