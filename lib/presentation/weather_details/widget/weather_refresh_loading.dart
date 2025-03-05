import 'package:flutter/material.dart';

class WeatherRefreshLoading extends StatelessWidget {
  const WeatherRefreshLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: LinearProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor.withAlpha(50),
        ),
      ),
    );
  }
}
