import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/common/widgets/empty_state.dart';
import 'package:weather_app/presentation/common/widgets/error_view.dart';
import 'package:weather_app/presentation/weather_details/bloc/forecast/weather_forecast_bloc.dart';
import 'package:weather_app/presentation/weather_details/bloc/forecast/weather_forecast_event.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_bloc.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_event.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_state.dart';
import 'package:weather_app/presentation/weather_details/widget/loading/current_weather_loading.dart';
import 'package:weather_app/presentation/weather_details/widget/weather_details_complementary_data.dart';
import 'package:weather_app/presentation/weather_details/widget/weather_details_forecast.dart';
import 'package:weather_app/presentation/weather_details/widget/weather_header.dart';
import 'package:weather_app/presentation/weather_details/widget/weather_refresh_loading.dart';

class WeatherDetailsBody extends StatelessWidget {
  const WeatherDetailsBody({
    required this.lat,
    required this.long,
    required this.cityName,
    super.key,
  });

  final double lat;
  final double long;
  final String? cityName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<WeatherDetailsBloc, WeatherDetailsState>(
      builder: (context, state) {
        final isLoading = state.status == WeatherDetailsStatus.loading;

        if (isLoading && state.weather == null) {
          return const CurrentWeatherLoading();
        }

        if (state.status == WeatherDetailsStatus.failure &&
            state.weather == null) {
          return ErrorView(
            error: state.error,
            onRetry:
                () => context.read<WeatherDetailsBloc>().add(
                  const LoadWeatherDetails(),
                ),
          );
        }

        final weather = state.weather;
        if (weather == null) {
          return EmptyState(
            title: l10n.noSavedCities,
            subtitle: l10n.addCityToSeeWeather,
            icon: Icons.location_city,
            action: ElevatedButton.icon(
              onPressed: () => _refreshWeatherDetails(context),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.actionRetry),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _refreshWeatherDetails(context),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: WeatherHeader(
                    weather: weather,
                    cityName: cityName,
                  ),
                ),
                centerTitle: true,
              ),
              if (isLoading)
                const SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  sliver: WeatherRefreshLoading(),
                ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 150,
                  child: WeatherDetailsComplementaryData(weather: weather),
                ),
              ),
              const SliverToBoxAdapter(child: WeatherDetailsForecast()),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.viewPaddingOf(context).bottom,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _refreshWeatherDetails(BuildContext context) {
    context.read<WeatherDetailsBloc>().add(const RefreshWeatherDetails());
    context.read<WeatherForecastBloc>().add(const RefreshWeatherForecast());
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('lat', lat));
    properties.add(DoubleProperty('long', long));
    properties.add(StringProperty('cityName', cityName));
  }
}
