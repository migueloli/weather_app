import 'package:flutter/material.dart';
import 'package:weather_app/presentation/common/widgets/shimmer_loading.dart';

class CitySearchLoadingItem extends StatelessWidget {
  const CitySearchLoadingItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ShimmerLoading(
      isLoading: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // City name placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 140,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Bookmark icon placeholder
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimaryContainer,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            // Arrow icon placeholder
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimaryContainer,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
