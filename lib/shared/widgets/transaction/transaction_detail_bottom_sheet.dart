import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/view_transactions/domain/models/view_transaction.dart';
import 'package:finhub/shared/widgets/transaction/transaction_detail_financials.dart';
import 'package:finhub/shared/widgets/transaction/transaction_detail_header.dart';
import 'package:finhub/shared/widgets/transaction/transaction_detail_trade_info.dart';
import 'package:finhub/shared/widgets/transaction/transaction_sheet_close_button.dart';
import 'package:finhub/shared/widgets/transaction/transaction_sheet_handle.dart';
import 'package:flutter/material.dart';

/// Shows the [TransactionDetailBottomSheet] over the current route.
///
/// Call this instead of [showModalBottomSheet] directly to ensure consistent
/// shape, shadow, and drag behaviour.
Future<void> showTransactionDetailSheet(BuildContext context, Transaction transaction) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => TransactionDetailBottomSheet(transaction: transaction),
  );
}

/// Modal bottom sheet showing the full detail of a [Transaction].
///
/// Drag handle plus a scrollable body, with the close button pinned to the
/// bottom regardless of scroll position.
class TransactionDetailBottomSheet extends StatelessWidget {
  /// Creates a [TransactionDetailBottomSheet] for [transaction].
  const TransactionDetailBottomSheet({required this.transaction, super.key});

  /// The transaction whose details are displayed.
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.appColors.surfaceDefault,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            const TransactionSheetHandle(),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TransactionDetailHeader(transaction: transaction),
                    TransactionDetailFinancials(transaction: transaction),
                    TransactionDetailTradeInfo(transaction: transaction),
                  ],
                ),
              ),
            ),
            const SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: TransactionSheetCloseButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
