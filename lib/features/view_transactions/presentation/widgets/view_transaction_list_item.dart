import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/features/view_transactions/domain/models/view_transaction.dart';
import 'package:finhub/shared/widgets/transaction/transaction_card.dart';
import 'package:finhub/shared/widgets/transaction/transaction_date_label.dart';
import 'package:flutter/material.dart';

/// One transaction row, preceded by a date header when the day changes from
/// the row above it.
///
/// Prop-driven and `const`-constructible so the lazy list can skip rebuilding
/// rows whose transaction and neighbour are unchanged.
class ViewTransactionListItem extends StatelessWidget {
  /// Creates a [ViewTransactionListItem].
  const ViewTransactionListItem({required this.transaction, required this.previousDate, super.key});

  /// Transaction rendered by this row.
  final Transaction transaction;

  /// Date of the row directly above, or `null` for the first row.
  final DateTime? previousDate;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    // The list is sorted as a whole, so the date header is emitted per row on
    // each change of day rather than per date bucket — that keeps the global
    // order intact under an amount or name sort while still reading as a
    // date-grouped list under the default date sort.
    final dateLabel = transactionDateLabel(
      date: transaction.transactionDate,
      previousDate: previousDate,
      todayLabel: l10n.dashboardTransactionDateToday,
      yesterdayLabel: l10n.dashboardTransactionDateYesterday,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dateLabel != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              dateLabel,
              style: AppTypography.bodySmall.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.6,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TransactionCard(transaction: transaction),
        ),
      ],
    );
  }
}
