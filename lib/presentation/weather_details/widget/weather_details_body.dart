import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';
import 'package:weather_app/presentation/common/widgets/error_view.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_bloc.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_event.dart';
import 'package:weather_app/presentation/weather_details/bloc/weather_details_state.dart';
import 'package:weather_app/presentation/weather_details/widget/daily_forecast/daily_forecast_list.dart';
import 'package:weather_app/presentation/weather_details/widget/hourly_forecast/hourly_forecast_list.dart';
import 'package:weather_app/presentation/weather_details/widget/loading_view.dart';
import 'package:weather_app/presentation/weather_details/widget/weather_details_complementary_data.dart';
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
          return const LoadingView();
        }

        if (state.status == WeatherDetailsStatus.failure &&
            state.weather == null) {
          return ErrorView(
            error: state.error,
            onRetry:
                () => context.read<WeatherDetailsBloc>().add(
                  LoadWeatherDetails(lat: lat, lon: long),
                ),
          );
        }

        final weather = state.weather;
        if (weather == null) {
          return Center(child: Text(l10n.weatherDataUnavailable));
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<WeatherDetailsBloc>().add(
              const RefreshWeatherDetails(),
            );
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 330 + MediaQuery.viewInsetsOf(context).top,
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
              // Hourly Forecast Section
              if (state.forecast != null)
                SliverToBoxAdapter(
                  child: HourlyForecastList(forecast: state.forecast!),
                ),
              if (state.forecast != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: DailyForecastList(forecast: state.forecast!),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('lat', lat));
    properties.add(DoubleProperty('long', long));
    properties.add(StringProperty('cityName', cityName));
  }
}
