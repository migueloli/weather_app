import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_bloc.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_state.dart';
import 'package:weather_app/presentation/city_search/widget/city_search_list_item.dart';
import 'package:weather_app/presentation/city_search/widget/loading/city_search_loading.dart';
import 'package:weather_app/presentation/common/widgets/empty_state.dart';
import 'package:weather_app/presentation/common/widgets/error_view.dart';

class CitySearchList extends StatelessWidget {
  const CitySearchList({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<CitySearchBloc, CitySearchState>(
      builder: (context, state) {
        if (state.status == CitySearchStatus.loading) {
          return const CitySearchLoading();
        }

        if (state.status == CitySearchStatus.failure) {
          return ErrorView(onRetry: onRetry, error: state.error);
        }

        if (state.status == CitySearchStatus.success && state.cities.isEmpty) {
          return EmptyState(
            title: l10n.errorNotFound,
            subtitle: l10n.searchForAnotherCity,
            icon: Icons.location_city_outlined,
          );
        }

        return RefreshIndicator(
          onRefresh: () async => onRetry(),
          child: ListView.builder(
            itemCount: state.cities.length,
            itemBuilder: (context, index) {
              final city = state.cities[index];
              return CitySearchListItem(
                city: city,
                isSaved: state.savedCities.contains(city.coordinates),
              );
            },
          ),
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
