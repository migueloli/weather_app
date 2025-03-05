import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/di/service_locator.dart';
import 'package:weather_app/core/routing/app_router.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:weather_app/presentation/settings/bloc/settings_event.dart';
import 'package:weather_app/presentation/settings/bloc/settings_state.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SettingsBloc(
            getSettingsUseCase: getIt(),
            saveLanguageUseCase: getIt(),
            saveUnitSystemUseCase: getIt(),
          )..add(const LoadSettings()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Weather App',
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ).copyWith(brightness: Brightness.dark),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(state.settings.language),
            localeResolutionCallback: (locale, supportedLocales) {
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
          );
        },
      ),
    );
  }
}
