import 'package:finhub/features/view_transactions/domain/models/view_transaction.dart';
import 'package:finhub/features/view_transactions/presentation/widgets/view_transaction_empty_sliver.dart';
import 'package:finhub/features/view_transactions/presentation/widgets/view_transaction_list_item.dart';
import 'package:finhub/features/view_transactions/presentation/widgets/view_transaction_pagination_sliver.dart';
import 'package:finhub/features/view_transactions/presentation/widgets/view_transaction_sort_header.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:flutter/material.dart';

/// Scrollable body of the transaction history: sort header, lazily built rows,
/// empty state, and pagination footer.
///
/// Prop-driven — the scroll controller and the loaded rows come from the
/// screen, and each sliver watches whatever provider it alone needs.
class ViewTransactionScrollView extends StatelessWidget {
  /// Creates a [ViewTransactionScrollView].
  const ViewTransactionScrollView({required this.scrollController, required this.transactions, super.key});

  /// Controller the screen uses to drive infinite-scroll pagination.
  final ScrollController scrollController;

  /// Filtered and sorted transactions to display.
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      // AlwaysScrollableScrollPhysics lets RefreshIndicator trigger even
      // when the list is shorter than the viewport.
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          sliver: SliverToBoxAdapter(
            child: ViewTransactionSortHeader(showSortMenu: transactions.length > 1),
          ),
        ),
        if (transactions.isEmpty) const ViewTransactionEmptySliver(),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          sliver: SliverList.builder(
            itemCount: transactions.length,
            // Rows arrive as the reader scrolls to them, the same entrance the
            // accounts and household transaction lists use. The history
            // paginates, so almost every row is built below the fold.
            itemBuilder: (context, index) => SettleIn(
              index: index,
              revealOnScroll: true,
              child: ViewTransactionListItem(
                transaction: transactions[index],
                previousDate: index == 0 ? null : transactions[index - 1].transactionDate,
              ),
            ),
          ),
        ),
        const ViewTransactionPaginationSliver(),
      ],
    );
  }
}
