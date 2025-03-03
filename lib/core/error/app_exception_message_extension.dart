import 'package:flutter/material.dart';
import 'package:weather_app/core/error/api_exception.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/error/app_exception_type.dart';
import 'package:weather_app/core/error/network_exception.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';

extension AppExceptionMessageExtension on AppException? {
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (l10n == null) return 'Something went wrong';

    if (this == null) return l10n.errorGeneric;

    // For API exceptions, we might want to use the server message
    if (this is ApiException && (this! as ApiException).message.isNotEmpty) {
      return (this! as ApiException).message;
    }

    // For network exceptions with custom messages
    if (this is NetworkException &&
        (this! as NetworkException).message.isNotEmpty) {
      return (this! as NetworkException).message;
    }

    // General message based on exception type
    return switch (this!.type) {
      AppExceptionType.networkConnection => l10n.errorNetwork,
      AppExceptionType.serverError => l10n.errorServer,
      AppExceptionType.client => l10n.errorClient,
      AppExceptionType.authorization => l10n.errorAuthorization,
      AppExceptionType.dataFormatting => l10n.errorDataFormat,
      AppExceptionType.cancelled => l10n.errorCancelled,
      AppExceptionType.locationPermissionDenied => l10n.errorLocationPermission,
      AppExceptionType.storageError => l10n.errorStorage,
      AppExceptionType.unknown => l10n.errorGeneric,
    };
  }

  IconData get errorIcon => switch (this?.type) {
    AppExceptionType.networkConnection => Icons.signal_wifi_off,
    AppExceptionType.serverError => Icons.cloud_off,
    AppExceptionType.client => Icons.error_outline,
    AppExceptionType.authorization => Icons.lock_outline,
    AppExceptionType.dataFormatting => Icons.data_array,
    AppExceptionType.cancelled => Icons.cancel_outlined,
    AppExceptionType.locationPermissionDenied => Icons.location_disabled,
    AppExceptionType.storageError => Icons.sd_card_alert_outlined,
    AppExceptionType.unknown => Icons.error_outline,
    null => Icons.error_outline,
  };

  bool get isNetworkError => this?.type == AppExceptionType.networkConnection;

  bool get isAuthError => this?.type == AppExceptionType.authorization;
}
