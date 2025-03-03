import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/exception/app_exception_message_extension.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_bloc.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_state.dart';
import 'package:weather_app/presentation/city_search/widget/city_search_list_item.dart';
import 'package:weather_app/presentation/city_search/widget/city_search_skeleton.dart';
import 'package:weather_app/presentation/common/blocs/city_save_bloc.dart';
import 'package:weather_app/presentation/common/blocs/city_save_state.dart';
import 'package:weather_app/presentation/common/widgets/empty_state.dart';
import 'package:weather_app/presentation/common/widgets/error_state.dart';

class CitySearchList extends StatelessWidget {
  const CitySearchList({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<CitySearchBloc, CitySearchState>(
      builder: (context, state) {
        if (state.status == CitySearchStatus.loading) {
          return const CitySearchSkeleton();
        }

        if (state.status == CitySearchStatus.failure) {
          return ErrorState(
            onRetry: onRetry,
            errorMessage:
                state.error?.getLocalizedMessage(context) ?? l10n.errorGeneric,
            icon: Icons.cloud_off,
          );
        }

        if (state.status == CitySearchStatus.success && state.cities.isEmpty) {
          return EmptyState(
            title: l10n.errorNotFound,
            subtitle: 'Try searching for another city name',
            icon: Icons.location_city_outlined,
          );
        }

        return BlocBuilder<CitySaveBloc, CitySaveState>(
          builder: (context, savedCitiesState) {
            return RefreshIndicator(
              onRefresh: () async {
                onRetry();
              },
              child: ListView.builder(
                itemCount: state.cities.length,
                itemBuilder: (context, index) {
                  final city = state.cities[index];
                  // Check if this city is already saved
                  final isSaved = savedCitiesState.cities.any(
                    (savedCity) =>
                        savedCity.lat == city.lat && savedCity.lon == city.lon,
                  );

                  return CitySearchListItem(city: city, isSaved: isSaved);
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onRetry', onRetry));
  }
}
