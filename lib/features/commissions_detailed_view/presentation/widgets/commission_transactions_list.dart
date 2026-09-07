import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/commissions_detailed_view/domain/models/commission_detail_transaction_card.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/providers/commissions_detailed_view_filter_provider.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/widgets/commission_transaction_card.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lazily built list of commission transaction cards.
///
/// Cards only — transactions are not grouped under date headers, because each
/// card already carries its own trade date in its footer and the header
/// repeated it directly above.
///
/// Watches [commissionDetailFilteredProvider] alone, so a search or sort change
/// rebuilds the list without touching the header card above it.
class CommissionTransactionsList extends ConsumerWidget {
  /// Creates a [CommissionTransactionsList] for [accountId].
  const CommissionTransactionsList({required this.accountId, super.key});

  /// Account whose filtered transactions are rendered.
  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(commissionDetailFilteredProvider(accountId));
    if (transactions.isEmpty) return const _EmptyState();
    return _TransactionsListView(transactions: transactions);
  }
}

/// Centred "no transactions" message.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  static const _style = TextStyle(fontFamily: 'Inter', fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.commissionDetailedViewNoTransactions,
        style: _style.copyWith(color: context.appColors.textSecondary),
      ),
    );
  }
}

/// Scrollable view over the filtered [transactions].
///
/// Split out so the `MediaQuery` keyboard-inset dependency lives here: the
/// per-frame rebuilds it causes while the keyboard animates stop at this
/// widget instead of re-running the provider-watching parent.
class _TransactionsListView extends StatelessWidget {
  const _TransactionsListView({required this.transactions});

  /// Transactions to render, already filtered and sorted.
  final List<CommissionDetailTransactionCard> transactions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // The viewport keeps its full height while the keyboard is up, so the
      // trailing gap grows by the bottom view inset to keep the last card
      // scrollable clear of the keyboard.
      padding: EdgeInsets.fromLTRB(16, 0, 16, 32 + MediaQuery.viewInsetsOf(context).bottom),
      itemCount: transactions.length,
      // Cards hold no scroll-sensitive state worth preserving off-screen.
      addAutomaticKeepAlives: false,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        // Rows arrive as the reader scrolls to them, the same entrance the
        // accounts list uses. `revealOnScroll` is what makes it worth having
        // here: the list is long, so most rows are built below the fold.
        child: SettleIn(
          index: index,
          revealOnScroll: true,
          child: CommissionTransactionCard(transaction: transactions[index]),
        ),
      ),
    );
  }
}
