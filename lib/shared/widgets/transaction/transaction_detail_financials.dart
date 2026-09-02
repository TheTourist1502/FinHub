import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/asset_class_labels.dart';
import 'package:finhub/core/utils/formatters/currency_formatter.dart';
import 'package:finhub/core/utils/formatters/number_formatter.dart';
import 'package:finhub/features/view_transactions/domain/models/view_transaction.dart';
import 'package:finhub/shared/widgets/transaction/transaction_detail_row.dart';
import 'package:finhub/shared/widgets/transaction/transaction_detail_section_label.dart';
import 'package:finhub/shared/widgets/transaction/transaction_filter.dart';
import 'package:flutter/material.dart';

/// Placeholder shown in place of a field the backend left empty.
const _kEmptyValue = '—';

/// Money section of the detail sheet: unit price, quantity, amount, asset
/// class, and description.
///
/// Unit price and quantity are always shown, **including when they are zero**:
/// a cash movement legitimately has a zero unit price, and hiding the row made
/// it look as though the backend had sent nothing. Only asset class is omitted
/// when empty, since a blank label carries no meaning. Description is shown
/// only for non-trades — it is the only detail a transaction that is neither
/// a BUY nor a SELL has to identify it, while a trade is already identified by
/// its security — falling back to a dash when the backend sends nothing.
class TransactionDetailFinancials extends StatelessWidget {
  /// Creates a [TransactionDetailFinancials] for [transaction].
  const TransactionDetailFinancials({required this.transaction, super.key});

  /// The transaction whose amounts are shown.
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final assetClass = transaction.assetClass ?? '';
    final description = transaction.transactionDescription?.trim() ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, thickness: 1, color: context.appColors.borderDefault),
          const SizedBox(height: 16),
          TransactionDetailSectionLabel(text: l10n.viewTransactionsDetailTitle),
          TransactionDetailRow(
            label: l10n.viewTransactionsDetailLabelPricePerUnit,
            value: formatCurrency(transaction.unitPrice),
          ),
          const SizedBox(height: 6),
          TransactionDetailRow(
            label: l10n.viewTransactionsDetailLabelQuantity,
            value: formatNumber(transaction.quantity),
          ),
          const SizedBox(height: 6),
          TransactionDetailRow(
            label: l10n.viewTransactionsDetailLabelAmount,
            value: formatCurrency(transaction.displayAmount),
          ),
          if (assetClass.isNotEmpty) ...[
            const SizedBox(height: 6),
            TransactionDetailRow(
              label: l10n.viewTransactionsDetailLabelAssetClass,
              value: assetClassLongLabel(l10n, assetClass),
            ),
          ],
          if (TransactionFilter.nonTrade.matches(transaction.transactionType)) ...[
            const SizedBox(height: 6),
            TransactionDetailRow(
              label: l10n.viewTransactionsDetailLabelDescription,
              value: description.isEmpty ? _kEmptyValue : description,
            ),
          ],
        ],
      ),
    );
  }
}
