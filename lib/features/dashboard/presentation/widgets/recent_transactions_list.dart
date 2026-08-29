import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:finhub/features/dashboard/presentation/widgets/recent_transactions_card.dart';
import 'package:finhub/features/dashboard/presentation/widgets/recent_transactions_empty_card.dart';
import 'package:finhub/features/dashboard/presentation/widgets/recent_transactions_view_all_button.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:flutter/material.dart';

/// Bordered card listing the recent transactions with a "view all" footer.
///
/// Falls back to [RecentTransactionsEmptyCard] when there is nothing to show.
class RecentTransactionsList extends StatelessWidget {
  /// Creates a [RecentTransactionsList] for [transactions].
  const RecentTransactionsList({required this.transactions, super.key});

  /// Transactions to render, in the order supplied.
  final List<RecentTransaction> transactions;

  /// Inset separator between two rows.
  static const Divider _rowDivider = Divider(
    height: 1,
    indent: 16,
    endIndent: 16,
    color: AppColors.neutral50,
  );

  /// Full-bleed separator above the footer action.
  static const Divider _footerDivider = Divider(height: 1, color: AppColors.neutral50);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) return const RecentTransactionsEmptyCard();

    final colors = context.appColors;
    final count = transactions.length;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderDefault),
      ),
      // A plain Column rather than a lazy list: the dashboard shows a short
      // fixed preview inside an outer scroll view, where a nested lazy list
      // would cost more than it saves.
      child: Column(
        children: [
          // Rows deal in one at a time rather than the whole card appearing at
          // once, and wait for the card to scroll into view before they do —
          // it sits at the bottom of the dashboard, well below the fold. Each
          // row is paired with the divider beneath it inside one [SettleIn],
          // so a separator never arrives before the row it separates. The
          // footer takes the next index and lands last.
          for (int i = 0; i < count; i++)
            SettleIn(
              index: i,
              revealOnScroll: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RecentTransactionCard(transaction: transactions[i]),
                  if (i < count - 1) _rowDivider,
                ],
              ),
            ),
          SettleIn(
            index: count,
            revealOnScroll: true,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [_footerDivider, RecentTransactionsViewAllButton()],
            ),
          ),
        ],
      ),
    );
  }
}
