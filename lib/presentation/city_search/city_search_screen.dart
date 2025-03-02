import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/di/service_locator.dart';
import 'package:weather_app/core/exception/app_exception_message_extension.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_bloc.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_event.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_state.dart';

class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final CitySearchBloc _citySearchBloc;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) {
        _citySearchBloc = CitySearchBloc(cityRepository: getIt());
        return _citySearchBloc;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.weatherSearchHint)),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.weatherSearchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _citySearchBloc.add(ClearSearch());
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (query) {
                  _citySearchBloc.add(SearchCities(query));
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<CitySearchBloc, CitySearchState>(
                builder: (context, state) {
                  if (state.status == CitySearchStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == CitySearchStatus.failure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.error?.getLocalizedMessage(context) ??
                                l10n.errorGeneric,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _citySearchBloc.add(
                                SearchCities(_searchController.text),
                              );
                            },
                            child: Text(l10n.actionRetry),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.status == CitySearchStatus.success &&
                      state.cities.isEmpty) {
                    return Center(child: Text(l10n.errorNotFound));
                  }

                  return ListView.builder(
                    itemCount: state.cities.length,
                    itemBuilder: (context, index) {
                      final city = state.cities[index];
                      return _buildCityItem(context, city);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityItem(BuildContext context, City city) {
    return ListTile(
      leading: const Icon(Icons.location_city),
      title: Text(city.name),
      subtitle: Text(
        city.state != null ? '${city.state}, ${city.country}' : city.country,
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // context.go('/weather/${city.lat},${city.lon}');
      },
    );
  }
}
