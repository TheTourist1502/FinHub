import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/errors/error_handler.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Full-widget error state display used when an async operation fails.
///
/// Shows a localised error message derived from [AppError] via [ErrorHandler],
/// an MDI alert icon, and an optional retry button.
///
/// Usage inside an `AsyncValue.error` branch:
/// ```dart
/// error: (err, _) => ErrorView(
///   error: err is AppError ? err : const UnknownError(),
///   onRetry: () => ref.invalidate(myProvider),
/// ),
/// ```
class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, this.onRetry, super.key});

  /// The typed domain error to display.
  final AppError error;

  /// Optional callback invoked when the user taps the retry button.
  /// When null the retry button is hidden.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final message = ErrorHandler.getMessage(error, context.l10n);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Iconify(Mdi.alert_circle_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton(onPressed: onRetry, child: Text(context.l10n.commonButtonRetry)),
            ],
          ],
        ),
      ),
    );
  }
}
