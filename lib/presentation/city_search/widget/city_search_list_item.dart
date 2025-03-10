import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/routing/app_router.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_bloc.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_event.dart';

class CitySearchListItem extends StatelessWidget {
  const CitySearchListItem({
    required this.city,
    required this.isSaved,
    super.key,
  });

  final City city;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'City ${city.name} in ${city.country}',
      hint: isSaved ? 'Saved city' : 'Not saved',
      child: ListTile(
        title: Text(
          city.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          city.state != null ? '${city.state}, ${city.country}' : city.country,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                key: ValueKey<bool>(isSaved),
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? Colors.blue : null,
                ),
                onPressed: () {
                  final citySearchBloc = context.read<CitySearchBloc>();
                  if (isSaved) {
                    citySearchBloc.add(RemoveCity(city));
                  } else {
                    citySearchBloc.add(SaveCity(city));
                  }
                },
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () {
          context.push(
            AppRoutes.weatherDetails(city.lat, city.lon, city.displayName),
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<City>('city', city));
    properties.add(DiagnosticsProperty<bool>('isSaved', isSaved));
  }
}
