import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/weekday_formatter.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/presentation/home/widget/home_city_card_weather.dart';

class HomeCityCard extends StatelessWidget {
  const HomeCityCard({
    required this.city,
    this.weather,
    this.onTap,
    this.onRemove,
    this.isLoading = false,
    super.key,
  });

  final City city;
  final Weather? weather;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // City info row with day abbreviation
              Row(
                children: [
                  // Day abbreviation
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(32),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      WeekdayFormatter.getWeekdayAbreviation(
                        context,
                        DateTime.now().weekday,
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          city.state != null
                              ? '${city.state}, ${city.country}'
                              : city.country,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (onRemove != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: onRemove,
                    ),
                ],
              ),

              const Divider(height: 24),
              HomeCityCardWeather(isLoading: isLoading, weather: weather),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<City>('city', city));
    properties.add(DiagnosticsProperty<Weather?>('weather', weather));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onRemove', onRemove));
    properties.add(DiagnosticsProperty<bool>('isLoading', isLoading));
  }
}
