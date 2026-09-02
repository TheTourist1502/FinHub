import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Full-width accent button that dismisses the transaction detail sheet.
class TransactionSheetCloseButton extends StatelessWidget {
  /// Creates a [TransactionSheetCloseButton].
  const TransactionSheetCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: colors.interactiveDefault,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            context.l10n.viewTransactionsDetailClose,
            style: AppTypography.sectionTitle.copyWith(
              color: colors.textOnAccent,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
