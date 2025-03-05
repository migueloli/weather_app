import 'package:equatable/equatable.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/data/models/app_settings.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.settings = const AppSettings(),
    this.error,
  });

  final SettingsStatus status;
  final AppSettings settings;
  final AppException? error;

  SettingsState copyWith({
    SettingsStatus? status,
    AppSettings? settings,
    AppException? Function()? error,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [status, settings, error];
}
