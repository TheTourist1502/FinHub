import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Ticker, activity name and quantity on the left with the trade price on the
/// right, closed by the card's inner divider.
class RealTimeTransactionsSummaryRow extends StatelessWidget {
  /// Creates a [RealTimeTransactionsSummaryRow].
  const RealTimeTransactionsSummaryRow({
    required this.title,
    required this.activity,
    required this.quantity,
    required this.price,
    super.key,
  });

  /// Ticker symbol, falling back to the CUSIP when the activity has none.
  final String title;

  /// Raw account activity name, e.g. "BUY".
  final String activity;

  /// Activity quantity, localised by this widget.
  final int quantity;

  /// Trade price, already formatted as currency by the caller.
  final String price;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderDefault)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.metricValueDense,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.viewTransactionsQuantity(quantity.toDouble()),
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            price,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
