import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/di/service_locator.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_bloc.dart';
import 'package:weather_app/presentation/city_search/widget/city_search_body.dart';

class CitySearchScreen extends StatelessWidget {
  const CitySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create:
          (context) => CitySearchBloc(
            searchCitiesUseCase: getIt(),
            saveCityUseCase: getIt(),
            getSavedCitiesUseCase: getIt(),
            removeSavedCityUseCase: getIt(),
          ),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.weatherSearchHint)),
        body: const CitySearchBody(),
      ),
    );
  }
}
