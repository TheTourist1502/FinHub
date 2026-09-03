import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/date_sort_utils.dart';
import 'package:finhub/features/households_detailed_view/domain/models/household_detail_view.dart';
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

/// Transactions tab for the household detail screen.
///
/// Provides a search bar, trade / non-trade filter chips, a globally sorted
/// transaction list with date headers, and a sort menu. Matches the Figma
/// transactions tab layout (node 1814-2642) adapted for household-level
/// transactions.
///
/// The search field, the chips, and the sort menu are all hidden when there
/// is nothing to filter or reorder — see [_showListControls].
class HouseholdsTransactionsTab extends StatefulWidget {
  /// Creates a [HouseholdsTransactionsTab].
  const HouseholdsTransactionsTab({required this.transactions, required this.onRefresh, super.key});

  /// All transactions for this household.
  final List<HouseholdDetailTransaction> transactions;

  /// Called when the user pulls to refresh.
  final Future<void> Function() onRefresh;

  @override
  State<HouseholdsTransactionsTab> createState() => _HouseholdsTransactionsTabState();
}

class _HouseholdsTransactionsTabState extends State<HouseholdsTransactionsTab> {
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

  List<HouseholdDetailTransaction> get _filtered {
    var list = widget.transactions;

    if (_activeFilter != TransactionFilter.all) {
      list = list.where((t) => _activeFilter.matches(t.transactionType)).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where(
            (t) => transactionMatchesSearch(
              query: q,
              securityName: t.securityName,
              tickerSymbol: t.tickerSymbol,
              transactionId: t.transactionId,
              accountName: t.accountName,
              accountType: t.accountType,
              assetClass: t.assetClass,
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
          return _sortDescending ? b.accountName.compareTo(a.accountName) : a.accountName.compareTo(b.accountName);
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
  double _displayAmount(HouseholdDetailTransaction t) => t.displayAmount;

  /// Converts a [HouseholdDetailTransaction] into the canonical [Transaction]
  /// model used by [TransactionCard] and the detail bottom sheet.
  Transaction _toTransaction(HouseholdDetailTransaction t) => Transaction(
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
    accountName: t.accountName,
    accountType: t.accountType,
  );

  /// One transaction row: its date header, when the day changes, and its card.
  ///
  /// The list is sorted as a whole, so the date header is emitted per row on
  /// each change of day rather than per date bucket — that keeps the global
  /// order intact under an amount or name sort while still reading as a
  /// date-grouped list under the default date sort.
  Widget _row({
    required int index,
    required List<HouseholdDetailTransaction> transactions,
    required AppLocalizations l10n,
    required AppColorTokens colors,
  }) {
    final tx = transactions[index];
    final txDate = tx.transactionDate;
    // Undated rows carry no header at all — a missing date is never rendered
    // as a placeholder or borrowed from the row above.
    final dateLabel = txDate == null
        ? null
        : transactionDateLabel(
            date: txDate,
            previousDate: index == 0 ? null : transactions[index - 1].transactionDate,
            todayLabel: l10n.householdDetailToday,
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
      child: RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── Search bar + type filter chips ────────────────────────────────
            if (_showListControls) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: AppSearchField(
                    hintText: l10n.householdDetailTransactionsSearchHint,
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
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
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
            ] else
              // Stands in for the search field's own top padding, so the count
              // row doesn't sit flush against the top of the tab.
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ── Count + sort row ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: SortHeaderRow(
                label: l10n.householdDetailAllTransactionsHeader.toUpperCase(),
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
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ── Grouped transaction list ──────────────────────────────────────
            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: NoRecordWidget(
                  message: isSearching
                      ? l10n.householdDetailTransactionsEmptySearch
                      : l10n.householdDetailNoTransactionsFound,
                ),
              )
            else
              // Built eagerly rather than through `SliverList.builder`: the
              // endpoint returns the household's transactions in one bounded
              // response (~30 rows), so there is nothing to defer and the
              // whole list can be laid out up front.
              SliverList.list(
                children: [
                  for (var index = 0; index < filtered.length; index++)
                    _row(index: index, transactions: filtered, l10n: l10n, colors: colors),
                ],
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
