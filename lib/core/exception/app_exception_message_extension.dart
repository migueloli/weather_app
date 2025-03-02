import 'package:flutter/material.dart';
import 'package:weather_app/core/exception/app_exception.dart';
import 'package:weather_app/core/exception/app_exception_type.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';

extension AppExceptionMessageExtension on AppException? {
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (this == null) return l10n.errorGeneric;

    return switch (this!.type) {
      AppExceptionType.networkConnection => l10n.errorNetwork,
      AppExceptionType.serverError => l10n.errorServer,
      AppExceptionType.unknown => l10n.errorGeneric,
    };
  }
}
