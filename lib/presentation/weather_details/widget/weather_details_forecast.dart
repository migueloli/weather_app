import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/presentation/common/widgets/error_view.dart';
import 'package:weather_app/presentation/weather_details/bloc/forecast/weather_forecast_bloc.dart';
import 'package:weather_app/presentation/weather_details/bloc/forecast/weather_forecast_event.dart';
import 'package:weather_app/presentation/weather_details/bloc/forecast/weather_forecast_state.dart';
import 'package:weather_app/presentation/weather_details/widget/daily_forecast/daily_forecast_list.dart';
import 'package:weather_app/presentation/weather_details/widget/hourly_forecast/hourly_forecast_list.dart';
import 'package:weather_app/presentation/weather_details/widget/loading/forecast_loading.dart';

class WeatherDetailsForecast extends StatelessWidget {
  const WeatherDetailsForecast({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherForecastBloc, WeatherForecastState>(
      builder: (context, state) {
        final isLoading = state.status == WeatherForecastStatus.loading;

        if (isLoading && state.forecast == null) {
          return const ForecastLoading();
        }

        if (state.status == WeatherForecastStatus.failure &&
            state.forecast == null) {
          return ErrorView(
            error: state.error,
            onRetry:
                () => context.read<WeatherForecastBloc>().add(
                  const LoadWeatherForecast(),
                ),
          );
        }

        final forecast = state.forecast;
        if (forecast == null) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            HourlyForecastList(forecast: forecast),
            DailyForecastList(forecast: forecast),
          ],
        );
      },
    );
  }
}
