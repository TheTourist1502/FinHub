import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Single inline `Label: value` line used in transaction detail lists.
///
/// Atomic and prop-driven so it can be reused across transaction surfaces.
///
/// Label and value are one flowing paragraph rather than two side-by-side
/// columns, so a long free-text value (a transaction description in
/// particular) wraps back to the left edge of the row instead of being
/// indented under the value column:
///
/// ```text
/// Description: some very long transaction text that
/// continues here rather than under the value column
/// ```
class TransactionDetailRow extends StatelessWidget {
  /// Creates a [TransactionDetailRow] rendering `label: value`.
  const TransactionDetailRow({required this.label, required this.value, super.key});

  /// Localised field name, rendered with a trailing colon.
  final String label;

  /// Pre-formatted value shown next to [label]; wraps over as many lines as needed.
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label:',
            style: AppTypography.bodySmall.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          // Keeps the original 8px gap between label and value, which a plain
          // space character would not reproduce.
          const WidgetSpan(child: SizedBox(width: 8)),
          TextSpan(
            text: value,
            style: AppTypography.bodyMedium.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
