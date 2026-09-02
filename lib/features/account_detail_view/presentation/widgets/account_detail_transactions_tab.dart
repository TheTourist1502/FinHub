import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/date_sort_utils.dart';
import 'package:finhub/features/account_detail_view/domain/models/account_transaction.dart';
import 'package:finhub/features/view_transactions/domain/models/view_transaction.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field.dart';
import 'package:finhub/shared/widgets/sort/sort_header_row.dart';
import 'package:finhub/shared/widgets/sort/sort_menu_button.dart';
import 'package:finhub/shared/widgets/transaction/transaction_card.dart';
import 'package:finhub/shared/widgets/transaction/transaction_date_label.dart';
import 'package:finhub/shared/widgets/transaction/transaction_filter.dart';
import 'package:finhub/shared/widgets/transaction/transaction_filter_chip.dart';
import 'package:finhub/shared/widgets/transaction/transaction_search.dart';
import 'package:flutter/material.dart';

/// Transactions tab content on the account detail screen.
///
/// Provides a search bar, trade / non-trade filter chips, a globally sorted
/// transaction list with date headers, and a sort menu. Matches the Figma
/// transactions tab design (node 1814-2642).
///
/// The search field, the chips, and the sort menu are all hidden when there
/// is nothing to filter or reorder — see [_showListControls].
class AccountDetailTransactionsTab extends StatefulWidget {
  /// Creates an [AccountDetailTransactionsTab].
  const AccountDetailTransactionsTab({required this.transactions, super.key});

  /// All transactions for this account.
  final List<AccountTransaction> transactions;

  @override
  State<AccountDetailTransactionsTab> createState() => _AccountDetailTransactionsTabState();
}

class _AccountDetailTransactionsTabState extends State<AccountDetailTransactionsTab> {
  TransactionFilter _activeFilter = TransactionFilter.all;
  String _searchQuery = '';
  String _sortField = 'date';
  bool _sortDescending = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AccountTransaction> get _filtered {
    var list = widget.transactions;

    // Type filter
    if (_activeFilter != TransactionFilter.all) {
      list = list.where((t) => _activeFilter.matches(t.transactionType)).toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where(
            (t) => transactionMatchesSearch(
              query: q,
              securityName: t.securityName,
              tickerSymbol: t.tickerSymbol ?? '',
              transactionId: t.transactionId,
              accountName: t.accountName ?? '',
              accountType: t.accountType ?? '',
              assetClass: t.assetClass ?? '',
              transactionType: t.transactionType,
            ),
          )
          .toList();
    }

    return [...list]..sort((a, b) {
      switch (_sortField) {
        // Ordered numerically on the figure the card actually renders behind
        // its `$`.
        case 'amount':
          final aAmount = _displayAmount(a);
          final bAmount = _displayAmount(b);
          return _sortDescending ? bAmount.compareTo(aAmount) : aAmount.compareTo(bAmount);
        case 'account':
          final aName = a.accountName ?? '';
          final bName = b.accountName ?? '';
          return _sortDescending ? bName.compareTo(aName) : aName.compareTo(bName);
        default:
          return compareDates(a.transactionDate, b.transactionDate, descending: _sortDescending);
      }
    });
  }

  /// Whether the search field and trade / non-trade chips are worth showing.
  ///
  /// Keyed off the full transaction set rather than [_filtered] so both stay
  /// put once rendered: a filter or search that narrows the list down to a
  /// single row must not remove the control the user needs to widen it again.
  /// With zero or one transaction there is nothing to narrow, so both are
  /// dropped entirely — the same rule the sort menu follows.
  bool get _showListControls => widget.transactions.length > 1;

  /// The dollar figure [TransactionCard] renders for [t], used as the
  /// `amount` sort key so the list's visible order matches its visible
  /// numbers.
  double _displayAmount(AccountTransaction t) => t.displayAmount;

  /// Converts an [AccountTransaction] into the canonical [Transaction] model
  /// used by [TransactionCard] and the detail bottom sheet.
  Transaction _toTransaction(AccountTransaction t) => Transaction(
    transactionId: t.transactionId,
    sourceId: t.sourceId,
    accountId: t.accountId,
    transactionType: t.transactionType,
    securityName: t.securityName,
    tickerSymbol: t.tickerSymbol,
    assetClass: t.assetClass,
    transactionDescription: t.transactionDescription,
    quantity: t.quantity,
    unitPrice: t.unitPrice,
    amount: t.amount,
    transactionDate: t.transactionDate,
    asOfDate: t.asOfDate,
    accountName: t.accountName ?? '',
    accountType: t.accountType ?? '',
  );

  /// One transaction row: its date header, when the day changes, and its card.
  ///
  /// The list is sorted as a whole, so the date header is emitted per row on
  /// each change of day rather than per date bucket — that keeps the global
  /// order intact under an amount or name sort while still reading as a
  /// date-grouped list under the default date sort.
  Widget _row({
    required int index,
    required List<AccountTransaction> transactions,
    required AppLocalizations l10n,
    required AppColorTokens colors,
  }) {
    final tx = transactions[index];
    final dateLabel = transactionDateLabel(
      date: tx.transactionDate,
      previousDate: index == 0 ? null : transactions[index - 1].transactionDate,
      todayLabel: l10n.accountDetailToday,
    );

    // Rows deal in one at a time as the reader scrolls to them, the same
    // entrance the accounts and transaction-history lists use.
    return SettleIn(
      index: index,
      revealOnScroll: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dateLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(
                dateLabel,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TransactionCard(transaction: _toTransaction(tx)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final filtered = _filtered;
    final isSearching = _searchQuery.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ── Search bar + type filter chips ────────────────────────────────
          if (_showListControls) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: AppSearchField(
                  hintText: l10n.accountDetailTransactionsSearchHint,
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 34,
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  children: [
                    TransactionFilterChip(
                      label: l10n.transactionFilterAllTransactions,
                      selected: _activeFilter == TransactionFilter.all,
                      onTap: () => setState(() => _activeFilter = TransactionFilter.all),
                    ),
                    const SizedBox(width: 8),
                    TransactionFilterChip(
                      label: l10n.transactionFilterTrade,
                      selected: _activeFilter == TransactionFilter.trade,
                      onTap: () => setState(() => _activeFilter = TransactionFilter.trade),
                    ),
                    const SizedBox(width: 8),
                    TransactionFilterChip(
                      label: l10n.transactionFilterNonTrade,
                      selected: _activeFilter == TransactionFilter.nonTrade,
                      onTap: () => setState(() => _activeFilter = TransactionFilter.nonTrade),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ] else
            // Stands in for the search field's own top padding, so the count
            // row doesn't sit flush against the top of the tab.
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // ── Count + sort row ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SortHeaderRow(
              label: l10n.accountDetailAllTransactionsHeader.toUpperCase(),
              sortMenuButton: filtered.length > 1
                  ? SortMenuButton(
                      fields: [
                        SortField(id: 'date', label: l10n.commonDate),
                        SortField(id: 'amount', label: l10n.commonAmount),
                        SortField(id: 'account', label: l10n.commonName),
                      ],
                      activeFieldId: _sortField,
                      isDescending: _sortDescending,
                      onChanged: (id, {required descending}) => setState(() {
                        _sortField = id;
                        _sortDescending = descending;
                      }),
                    )
                  : null,
            ),
          ),

          // ── Grouped transaction list ──────────────────────────────────────
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: NoRecordWidget(
                message: isSearching ? l10n.accountDetailTransactionsEmptySearch : null,
              ),
            )
          else
            // Built eagerly rather than through `SliverList.builder`: the
            // endpoint returns the account's transactions in one bounded
            // response (~30 rows), so there is nothing to defer and the whole
            // list can be laid out up front.
            SliverList.list(
              children: [
                for (var index = 0; index < filtered.length; index++)
                  _row(index: index, transactions: filtered, l10n: l10n, colors: colors),
              ],
            ),
          // The screen sets `resizeToAvoidBottomInset: false`, so the viewport
          // keeps its full height while the keyboard is up. Growing the trailing
          // gap by the bottom view inset keeps the last card scrollable clear of
          // the keyboard rather than stranded behind it.
          SliverToBoxAdapter(
            child: SizedBox(height: 16 + MediaQuery.viewInsetsOf(context).bottom),
          ),
        ],
      ),
    );
  }
}
