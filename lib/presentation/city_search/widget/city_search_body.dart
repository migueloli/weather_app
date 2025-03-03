import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_bloc.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_event.dart';
import 'package:weather_app/presentation/city_search/widget/city_search_list.dart';

class CitySearchBody extends StatefulWidget {
  const CitySearchBody({super.key});

  @override
  State<CitySearchBody> createState() => _CitySearchBodyState();
}

class _CitySearchBodyState extends State<CitySearchBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.weatherSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
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
              citySearchBloc.add(SearchCities(_searchController.text));
            },
          ),
        ),
      ],
    );
  }
}
