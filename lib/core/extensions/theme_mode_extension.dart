import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

extension ThemeModeExtension on List<ThemeMode> {
  ThemeMode byNameWithDefault(
    String? toParse, {
    ThemeMode toDefault = ThemeMode.system,
  }) {
    if (toParse == null) return toDefault;
    return firstWhereOrNull((element) => element.name == toParse) ?? toDefault;
  }
}
