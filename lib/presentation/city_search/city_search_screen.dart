import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/di/service_locator.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_bloc.dart';
import 'package:weather_app/presentation/city_search/widget/city_search_body.dart';
import 'package:weather_app/presentation/common/blocs/city_save_bloc.dart';
import 'package:weather_app/presentation/common/blocs/city_save_event.dart';

class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<CitySearchBloc>()),
        BlocProvider(
          create: (context) {
            final citySaveBloc = getIt<CitySaveBloc>();
            citySaveBloc.add(LoadSavedCities());
            return citySaveBloc;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.weatherSearchHint)),
        body: CitySearchBody(searchController: _searchController),
      ),
    );
  }
}
