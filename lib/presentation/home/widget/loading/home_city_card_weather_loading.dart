import 'package:flutter/material.dart';
import 'package:weather_app/presentation/common/widgets/shimmer_loading.dart';
import 'package:weather_app/presentation/home/widget/loading/home_city_card_weather_placeholder.dart';

class HomeCityCardWeatherLoading extends StatelessWidget {
  const HomeCityCardWeatherLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerLoading(
      isLoading: true,
      child: HomeCityCardWeatherPlaceholder(),
    );
  }
}
