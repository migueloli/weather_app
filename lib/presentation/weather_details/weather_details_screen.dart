import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/di/service_locator.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/common/blocs/city_save_bloc.dart';
import 'package:weather_app/presentation/common/blocs/city_save_event.dart';
import 'package:weather_app/presentation/common/blocs/city_save_state.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_bloc.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_event.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_state.dart';

class WeatherDetailsScreen extends StatefulWidget {
  const WeatherDetailsScreen({required this.lat, required this.lon, super.key});
  final double lat;
  final double lon;

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('lat', lat));
    properties.add(DoubleProperty('lon', lon));
  }
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  late final WeatherBloc _weatherBloc;
  late final CitySaveBloc _savedCitiesBloc;

  @override
  void initState() {
    super.initState();
    _weatherBloc = getIt<WeatherBloc>();
    _savedCitiesBloc = getIt<CitySaveBloc>();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Load weather data
      _weatherBloc.add(FetchWeather(lat: widget.lat, lon: widget.lon));

      // Check if this city is saved
      _savedCitiesBloc.add(CheckCitySaved(lat: widget.lat, lon: widget.lon));
      _savedCitiesBloc.add(LoadSavedCities());
    });
  }

  void _handleSaveToggle(BuildContext context) {
    final state = context.read<CitySaveBloc>().state;
    final weatherState = context.read<WeatherBloc>().state;

    if (state.isCurrentCitySaved) {
      // Remove from saved cities
      context.read<CitySaveBloc>().add(
        RemoveCity(lat: widget.lat, lon: widget.lon),
      );
    } else if (weatherState is WeatherLoaded && weatherState.city != null) {
      // Add to saved cities if we have city data
      context.read<CitySaveBloc>().add(AddCity(weatherState.city!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _weatherBloc),
        BlocProvider(create: (context) => _savedCitiesBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.weatherDetails),
          actions: [
            // Save/unsave button in app bar
            BlocBuilder<CitySaveBloc, CitySaveState>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    state.isCurrentCitySaved
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: state.isCurrentCitySaved ? Colors.blue : null,
                  ),
                  onPressed: () {
                    _handleSaveToggle(context);
                  },
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _weatherBloc.add(FetchWeather(lat: widget.lat, lon: widget.lon));
          },
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is WeatherError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.errorMessage ?? l10n.errorGeneric),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _weatherBloc.add(
                            FetchWeather(lat: widget.lat, lon: widget.lon),
                          );
                        },
                        child: Text(l10n.actionRetry),
                      ),
                    ],
                  ),
                );
              }

              if (state is WeatherLoaded) {
                return _buildWeatherContent(context, state);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherContent(BuildContext context, WeatherLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    final weather = state.weather;
    final mainCondition =
        weather.weather.isNotEmpty ? weather.weather.first : null;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.lastUpdated != null)
              Text(
                'Last updated: ${_formatLastUpdated(state.lastUpdated!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),

            const SizedBox(height: 16),

            // City name and country
            Center(
              child: Text(
                '${weather.name}, ${weather.sys.country}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),

            const SizedBox(height: 24),

            // Weather icon and temperature
            Center(
              child: Column(
                children: [
                  // Weather icon from URL
                  if (mainCondition != null)
                    Image.network(
                      mainCondition.iconUrl,
                      width: 100,
                      height: 100,
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.cloud,
                            size: 80,
                            color: Colors.blue,
                          ),
                    ),
                  const SizedBox(height: 16),
                  // Temperature
                  Text(
                    '${weather.main.temp.toStringAsFixed(1)}°C',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  // Weather description
                  Text(
                    mainCondition?.description.toUpperCase() ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // Feels like
                  Text(
                    'Feels like ${weather.main.feelsLike.toStringAsFixed(1)}°C',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Min/Max Temperature row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTemperatureItem(
                  context,
                  'Min',
                  '${weather.main.tempMin.toStringAsFixed(1)}°C',
                  Icons.arrow_downward,
                ),
                _buildTemperatureItem(
                  context,
                  'Max',
                  '${weather.main.tempMax.toStringAsFixed(1)}°C',
                  Icons.arrow_upward,
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Divider(),

            // Weather details
            _buildWeatherDetailItem(
              context,
              Icons.water_drop,
              l10n.weatherHumidity,
              '${weather.main.humidity}%',
            ),
            const Divider(),
            _buildWeatherDetailItem(
              context,
              Icons.air,
              l10n.weatherWindSpeed,
              '${weather.wind.speed} m/s',
            ),
            const Divider(),
            _buildWeatherDetailItem(
              context,
              Icons.compress,
              l10n.weatherPressure,
              '${weather.main.pressure} hPa',
            ),

            ...[
              const Divider(),
              _buildWeatherDetailItem(
                context,
                Icons.cloud,
                'Cloudiness',
                '${weather.clouds.all}%',
              ),
            ],

            ...[
              const Divider(),
              _buildWeatherDetailItem(
                context,
                Icons.visibility,
                'Visibility',
                '${(weather.visibility / 1000).toStringAsFixed(1)} km',
              ),
            ],

            // Sunrise and sunset times
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSunriseSunsetItem(
                  context,
                  'Sunrise',
                  _formatTimeFromUnix(weather.sys.sunrise, weather.timezone),
                  Icons.wb_sunny,
                ),
                _buildSunriseSunsetItem(
                  context,
                  'Sunset',
                  _formatTimeFromUnix(weather.sys.sunset, weather.timezone),
                  Icons.nightlight_round,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSunriseSunsetItem(
    BuildContext context,
    String label,
    String time,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: label == 'Sunrise' ? Colors.amber : Colors.indigo),
        const SizedBox(height: 4),
        Text(label),
        Text(
          time,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Add a helper method for last updated time
  String _formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  // Helper to format Unix timestamps with timezone adjustment
  String _formatTimeFromUnix(int unixTime, int timezone) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      unixTime * 1000,
    ).add(Duration(seconds: timezone));
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildWeatherDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
