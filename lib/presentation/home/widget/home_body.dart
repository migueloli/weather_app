import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/routing/app_router.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/common/widgets/empty_state.dart';
import 'package:weather_app/presentation/common/widgets/error_view.dart';
import 'package:weather_app/presentation/common/widgets/shimmer_loading.dart';
import 'package:weather_app/presentation/home/bloc/home_bloc.dart';
import 'package:weather_app/presentation/home/bloc/home_event.dart';
import 'package:weather_app/presentation/home/bloc/home_state.dart';
import 'package:weather_app/presentation/home/widget/home_city_card.dart';
import 'package:weather_app/presentation/home/widget/loading/home_city_card_loading.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final homeBloc = context.read<HomeBloc>();

    return RefreshIndicator(
      onRefresh: () async {
        homeBloc.add(const LoadSavedCities());
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading && state.cities.isEmpty) {
            // Show shimmer loading placeholders instead of CircularProgressIndicator
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 3, // Show 3 placeholder cards
              itemBuilder: (context, index) {
                return const ShimmerLoading(
                  isLoading: true,
                  child: HomeCityCardLoading(),
                );
              },
            );
          }

          if (state.status == HomeStatus.failure) {
            return ErrorView(
              error: state.error,
              onRetry: () {
                homeBloc.add(const LoadSavedCities());
              },
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

              return HomeCityCard(
                city: city,
                onTap: () {
                  context.push(
                    AppRoutes.weatherDetails(city.lat, city.lon, city.name),
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
