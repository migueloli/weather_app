import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/di/service_locator.dart';
import 'package:weather_app/core/routing/app_router.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/home/bloc/home_bloc.dart';
import 'package:weather_app/presentation/home/widget/home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create:
          (context) => HomeBloc(
            getSavedCitiesUseCase: getIt(),
            removeSavedCityUseCase: getIt(),
            getWeatherUseCase: getIt(),
          ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push(AppRoutes.settings),
              tooltip: l10n.settings,
            ),
          ],
        ),
        body: const HomeBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(AppRoutes.citySearch),
          tooltip: l10n.searchForCities,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
