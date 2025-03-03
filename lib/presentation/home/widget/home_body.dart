import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/routing/app_router.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/common/widgets/empty_state.dart';
import 'package:weather_app/presentation/common/widgets/error_state.dart';
import 'package:weather_app/presentation/home/bloc/home_bloc.dart';
import 'package:weather_app/presentation/home/bloc/home_event.dart';
import 'package:weather_app/presentation/home/bloc/home_state.dart';
import 'package:weather_app/presentation/home/widget/home_city_card.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final homeBloc = BlocProvider.of<HomeBloc>(context);

    return RefreshIndicator(
      onRefresh: () async {
        homeBloc.add(const RefreshSavedCities());
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading && state.cities.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == HomeStatus.failure) {
            return ErrorState(
              errorMessage: state.errorMessage ?? l10n.errorGeneric,
              onRetry: () {
                homeBloc.add(const RefreshSavedCities());
              },
              icon: Icons.cloud_off,
            );
          }

          if (state.cities.isEmpty) {
            return EmptyState(
              title: l10n.noSavedCities,
              subtitle: l10n.addCityToSeeWeather,
              icon: Icons.location_city,
              action: ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.citySearch),
                icon: const Icon(Icons.add),
                label: Text(l10n.searchForCities),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.cities.length,
            itemBuilder: (context, index) {
              final city = state.cities[index];
              final weather = state.getWeatherForCity(city);
              final isLoading = state.isLoadingWeatherForCity(city);

              return HomeCityCard(
                city: city,
                weather: weather,
                isLoading: isLoading,
                onTap: () {
                  context.pushNamed(
                    'weather-details',
                    queryParameters: {
                      'lat': city.lat.toString(),
                      'lon': city.lon.toString(),
                    },
                  );
                },
                onRemove: () {
                  homeBloc.add(RemoveSavedCity(city: city));
                },
              );
            },
          );
        },
      ),
    );
  }
}
