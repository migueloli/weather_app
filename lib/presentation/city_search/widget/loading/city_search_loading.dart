import 'package:flutter/material.dart';
import 'package:weather_app/presentation/city_search/widget/loading/city_search_loading_item.dart';

class CitySearchLoading extends StatelessWidget {
  const CitySearchLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5, // Show 5 skeleton items
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return const CitySearchLoadingItem();
      },
      separatorBuilder: (_, _) => const SizedBox(height: 8),
    );
  }
}
