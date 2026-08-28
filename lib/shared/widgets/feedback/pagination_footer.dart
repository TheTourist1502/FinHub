import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Footer rendered below an infinite-scrolling list.
///
/// Shows exactly one of three states:
/// - Circular progress while the next page is loading.
/// - Inline [errorLabel] with a retry button when pagination failed.
/// - Empty spacing otherwise (idle or all pages exhausted).
///
/// Atomic widget: prop-driven, no Riverpod dependency. The caller supplies
/// the localised error label and the retry callback.
class PaginationFooter extends StatelessWidget {
  /// Creates a [PaginationFooter].
  const PaginationFooter({
    required this.isLoadingMore,
    required this.hasError,
    required this.errorLabel,
    required this.onRetry,
    super.key,
  });

  /// `true` while the next page request is in-flight.
  final bool isLoadingMore;

  /// `true` when the most recent pagination request failed.
  final bool hasError;

  /// Localised message shown when pagination fails.
  final String errorLabel;

  /// Invoked when the user taps the retry button after a pagination error.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (isLoadingMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: colors.interactiveDefault,
            ),
          ),
        ),
      );
    }

    if (hasError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorLabel,
              style: AppTypography.bodySmall.copyWith(color: colors.statusErrorDefault),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onRetry,
              child: Text(
                context.l10n.commonButtonRetry,
                style: AppTypography.bodySmall.copyWith(
                  color: colors.interactiveDefault,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Idle or end-of-list — just bottom padding.
    return const SizedBox(height: 8);
  }
}
