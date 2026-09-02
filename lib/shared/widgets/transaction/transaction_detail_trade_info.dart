import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/view_transactions/domain/models/view_transaction.dart';
import 'package:finhub/shared/widgets/transaction/transaction_detail_cell.dart';
import 'package:finhub/shared/widgets/transaction/transaction_detail_section_label.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Trade-details section of the detail sheet: trade id and trade date side by side.
class TransactionDetailTradeInfo extends StatelessWidget {
  /// Creates a [TransactionDetailTradeInfo] for [transaction].
  const TransactionDetailTradeInfo({required this.transaction, super.key});

  /// The transaction whose trade metadata is shown.
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tradeDate = transaction.transactionDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 1, thickness: 1, color: context.appColors.borderDefault),
        const SizedBox(height: 16),
        TransactionDetailSectionLabel(text: l10n.viewTransactionsDetailLabelTradeDetails),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TransactionDetailCell(
                label: l10n.viewTransactionsDetailLabelTradeId.toUpperCase(),
                value: transaction.transactionId,
              ),
            ),
            // No trade date from the backend means no date cell at all — the
            // trade id then takes the full row rather than sitting beside a
            // placeholder. `format`, not `formatLocal`: a trade date is a pure
            // calendar date and converting it could shift the day.
            if (tradeDate != null) ...[
              const SizedBox(width: 16),
              Expanded(
                child: TransactionDetailCell(
                  label: l10n.viewTransactionsDetailLabelDate.toUpperCase(),
                  value: DateFormat('MMMM d, yyyy').format(tradeDate),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
