import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/error/app_exception_message_extension.dart';
import 'package:weather_app/l10n/gen/app_localizations.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.error,
    this.onRetry,
    this.onGoBack,
    this.isSmall = false,
    super.key,
  });

  final AppException? error;
  final VoidCallback? onRetry;
  final VoidCallback? onGoBack;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (isSmall) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              error?.errorIcon ?? Icons.error_outline,
              size: 24,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 8),
            Text(
              error?.getLocalizedMessage(context) ?? l10n.errorGeneric,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.actionRetry),
              ),
            if (onGoBack != null)
              TextButton.icon(
                onPressed: onGoBack,
                icon: const Icon(Icons.arrow_back),
                label: Text(l10n.actionGoBack),
              ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              error?.errorIcon ?? Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              error?.getLocalizedMessage(context) ?? l10n.errorGeneric,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.actionRetry),
              ),
            if (onGoBack != null)
              TextButton.icon(
                onPressed: onGoBack,
                icon: const Icon(Icons.arrow_back),
                label: Text(l10n.actionGoBack),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppException>('error', error));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onRetry', onRetry));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onGoBack', onGoBack));
    properties.add(DiagnosticsProperty<bool>('isSmall', isSmall));
  }
}
