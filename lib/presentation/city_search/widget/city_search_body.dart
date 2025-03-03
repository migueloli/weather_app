import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_bloc.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_event.dart';
import 'package:weather_app/presentation/city_search/widget/city_search_list.dart';

class CitySearchBody extends StatelessWidget {
  const CitySearchBody({required this.searchController, super.key});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final citySearchBloc = BlocProvider.of<CitySearchBloc>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            textInputAction: TextInputAction.search,
            controller: searchController,
            decoration: InputDecoration(
              hintText: l10n.weatherSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  BlocProvider.of<CitySearchBloc>(context).add(ClearSearch());
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (query) {
              citySearchBloc.add(SearchCities(query));
            },
          ),
        ),
        Expanded(
          child: CitySearchList(
            onRetry: () {
              citySearchBloc.add(SearchCities(searchController.text));
            },
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<TextEditingController>(
        'searchController',
        searchController,
      ),
    );
  }
}
