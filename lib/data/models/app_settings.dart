import 'package:equatable/equatable.dart';
import 'package:weather_app/data/entity/unity_system.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.language = 'en',
    this.unitSystem = UnitSystem.metric,
  });

  final String language;
  final UnitSystem unitSystem;

  AppSettings copyWith({String? language, UnitSystem? unitSystem}) {
    return AppSettings(
      language: language ?? this.language,
      unitSystem: unitSystem ?? this.unitSystem,
    );
  }

  @override
  List<Object?> get props => [language, unitSystem];
}
