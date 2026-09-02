import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Pill-shaped selectable chip used for the transaction type filter row
/// (All Transactions / Trade / Non-Trade).
///
/// Visually matches the chips on the View Transactions screen
/// (`ViewTransactionFilterChips`).
class TransactionFilterChip extends StatelessWidget {
  /// Creates a [TransactionFilterChip].
  const TransactionFilterChip({required this.label, required this.selected, required this.onTap, super.key});

  /// Chip display label.
  final String label;

  /// Whether this chip is the active filter.
  final bool selected;

  /// Called when the chip is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? colors.bgBrandNavyBlue : colors.surfaceDefault,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: selected ? colors.bgBrandNavyBlue : colors.borderDefault,
          ),
          boxShadow: selected ? [BoxShadow(color: colors.cardShadow, blurRadius: 1, offset: const Offset(0, 1))] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: selected ? colors.textOnAccent : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
