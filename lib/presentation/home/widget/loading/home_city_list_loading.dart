import 'package:flutter/material.dart';
import 'package:weather_app/presentation/home/widget/loading/home_city_card_loading.dart';

class HomeCityListLoading extends StatelessWidget {
  const HomeCityListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: 3,
      itemBuilder: (context, index) {
        return const HomeCityCardLoading();
      },
      separatorBuilder: (_, _) => const SizedBox(height: 8),
    );
  }
}
