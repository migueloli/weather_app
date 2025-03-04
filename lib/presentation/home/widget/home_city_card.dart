import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/data/models/city.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
              // City info row
              Row(
                children: [
                  const Icon(Icons.location_city, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          city.state != null
                              ? '${city.state}, ${city.country}'
                              : city.country,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (onRemove != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: onRemove,
                      tooltip: 'Remove city',
                    ),
                ],
              ),

              const Divider(height: 24),

              // Weather info section
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else if (weather != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (weather!.weather.isNotEmpty)
                      Image.network(
                        weather!.weather.first.iconUrl,
                        width: 64,
                        height: 64,
                        errorBuilder:
                            (_, _, _) => const Icon(Icons.wb_sunny, size: 48),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${weather!.main.temp.round()}°C',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            weather!.weather.isNotEmpty
                                ? weather!.weather.first.main
                                : '',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.water_drop, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${weather!.main.humidity}%',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.air, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${weather!.wind.speed} m/s',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      l10n.weatherDataUnavailable,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ),
                ),
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
