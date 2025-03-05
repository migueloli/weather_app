import 'package:equatable/equatable.dart';
import 'package:weather_app/data/models/daily_forecast_data.dart';
import 'package:weather_app/data/models/forecast_city.dart';
import 'package:weather_app/data/models/forecast_entry.dart';

class Forecast extends Equatable {
  const Forecast({required this.list, required this.city});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      list:
          (json['list'] as List)
              .map((e) => ForecastEntry.fromJson(e as Map<String, dynamic>))
              .toList(),
      city: ForecastCity.fromJson(json['city'] as Map<String, dynamic>),
    );
  }

  final List<ForecastEntry> list;
  final ForecastCity city;

  // Helper method to group forecast entries by date for daily view
  List<DailyForecastData> getDailyForecast() {
    final Map<String, List<ForecastEntry>> groupedByDay = {};

    for (final entry in list) {
      // Get date string (YYYY-MM-DD) from timestamp
      final date = DateTime.fromMillisecondsSinceEpoch(entry.dt * 1000);
      final dateString =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (!groupedByDay.containsKey(dateString)) {
        groupedByDay[dateString] = [];
      }

      groupedByDay[dateString]!.add(entry);
    }

    // Convert the grouped data to DailyForecastData objects
    return groupedByDay.entries.map((entry) {
        final entries = entry.value;

        // Find min/max temperatures for the day
        double minTemp = double.infinity;
        double maxTemp = double.negativeInfinity;

        for (final forecastEntry in entries) {
          if (forecastEntry.main.tempMin < minTemp) {
            minTemp = forecastEntry.main.tempMin;
          }
          if (forecastEntry.main.tempMax > maxTemp) {
            maxTemp = forecastEntry.main.tempMax;
          }
        }

        // Use noon data or the middle entry for the day's representation
        final representativeEntry =
            entries.length > 2 ? entries[entries.length ~/ 2] : entries.first;

        return DailyForecastData(
          date: DateTime.parse(entry.key),
          minTemp: minTemp,
          maxTemp: maxTemp,
          weatherCondition:
              representativeEntry.weather.isNotEmpty
                  ? representativeEntry.weather.first
                  : null,
          entries: entries,
        );
      }).toList()
      ..sort((a, b) => a.date.compareTo(b.date)); // Sort by date
  }

  @override
  List<Object?> get props => [list, city];
}
