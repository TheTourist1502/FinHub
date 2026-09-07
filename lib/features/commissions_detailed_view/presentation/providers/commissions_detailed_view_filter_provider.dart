import 'package:finhub/core/utils/date_sort_utils.dart';
import 'package:finhub/features/commissions_detailed_view/domain/models/commission_detail_transaction_card.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/providers/commissions_detailed_view_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sort field identifiers used by the commission detail transaction list.
abstract final class CommissionDetailSortField {
  /// Sort by commission earned.
  static const String commission = 'commission';

  /// Sort by the transaction (investment) amount.
  static const String transactionAmount = 'transactionAmount';

  /// Sort by earned date; the default.
  static const String date = 'date';

  /// Sort by security name.
  static const String name = 'name';
}

/// Holds the text typed into the commission detail search field.
class _SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  // Write-only state — callers set the query; reads go through the provider.
  // ignore: avoid_setters_without_getters
  set query(String value) => state = value;
}

/// Active search query for the commission detail list.
///
/// `autoDispose` so the query resets once the screen is popped, matching the
/// freshly created search controller on the next visit.
// ignore: specify_nonobvious_property_types
final commissionDetailSearchQueryProvider = NotifierProvider.autoDispose<_SearchQueryNotifier, String>(
  _SearchQueryNotifier.new,
);

/// Holds the active sort field id (see [CommissionDetailSortField]).
class _SortFieldNotifier extends Notifier<String> {
  @override
  String build() => CommissionDetailSortField.date;

  // Write-only state — callers set the field; reads go through the provider.
  // ignore: avoid_setters_without_getters
  set field(String value) => state = value;
}

/// Active sort field for the commission detail list; `autoDispose` so it
/// returns to the default date sort on the next visit.
// ignore: specify_nonobvious_property_types
final commissionDetailSortFieldProvider = NotifierProvider.autoDispose<_SortFieldNotifier, String>(
  _SortFieldNotifier.new,
);

/// Holds the sort direction; `true` is descending.
class _SortDescendingNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  // Write-only state — callers set the direction; reads go through the provider.
  // ignore: avoid_setters_without_getters
  set descending(bool value) => state = value;
}

/// Active sort direction for the commission detail list; `autoDispose` so it
/// returns to descending on the next visit.
// ignore: specify_nonobvious_property_types
final commissionDetailSortDescendingProvider = NotifierProvider.autoDispose<_SortDescendingNotifier, bool>(
  _SortDescendingNotifier.new,
);

/// Comparator for [field] in the requested direction.
///
/// Resolved once per sort rather than switching on [field] inside the
/// comparator, which would re-run the branch on every one of the O(n log n)
/// comparisons.
///
/// Every field but the date is written ascending and flipped by swapping the
/// arguments. The date field resolves its own direction through
/// [compareDates] instead: [tradeDate] is nullable, and swapping arguments
/// would float the undated rows to the top of a descending sort rather than
/// keeping them last.
Comparator<CommissionDetailTransactionCard> _comparatorFor(String field, {required bool descending}) {
  final Comparator<CommissionDetailTransactionCard> ascending;
  switch (field) {
    case CommissionDetailSortField.commission:
      ascending = (a, b) => a.commissionEarned.compareTo(b.commissionEarned);
    case CommissionDetailSortField.transactionAmount:
      ascending = (a, b) => a.transactionAmount.compareTo(b.transactionAmount);
    case CommissionDetailSortField.name:
      ascending = (a, b) => a.securityName.compareTo(b.securityName);
    default:
      return (a, b) => compareDates(a.tradeDate, b.tradeDate, descending: descending);
  }
  return descending ? (a, b) => ascending(b, a) : ascending;
}

/// Currency decoration a reader copies off a card along with the digits —
/// the symbol, thousands separators and any spacing around them.
final RegExp _amountNoise = RegExp(r'[,$\s]');

/// Search-filtered and sorted transactions for [accountId].
///
/// Derived here so the sort header and the list can each watch the result
/// without rebuilding the header card or the search field.
// ignore: specify_nonobvious_property_types
final commissionDetailFilteredProvider = Provider.autoDispose.family<List<CommissionDetailTransactionCard>, String>((
  ref,
  accountId,
) {
  final async = ref.watch(commissionDetailedViewProvider(accountId));
  final all = async is AsyncData<List<CommissionDetailTransactionCard>>
      ? async.value
      : const <CommissionDetailTransactionCard>[];
  final query = ref.watch(commissionDetailSearchQueryProvider);
  final field = ref.watch(commissionDetailSortFieldProvider);
  final descending = ref.watch(commissionDetailSortDescendingProvider);

  // `where(...).toList()` already yields a fresh list, so only the unfiltered
  // path needs its own copy before the in-place sort.
  final List<CommissionDetailTransactionCard> sorted;
  if (query.isEmpty) {
    sorted = [...all];
  } else {
    final q = query.toLowerCase();
    // The card renders amounts as "$1,234.50" but the model holds `1234.5`, so
    // the grouping, symbol and spaces come off the query before it is matched
    // against a fixed-decimal rendering of each figure. Without this, typing
    // an amount exactly as it appears on the card never matched anything.
    final qNum = q.replaceAll(_amountNoise, '');
    sorted = all
        .where(
          // `displayName` rather than the two name fields, so the ticker
          // matches on its own *and* "apple inc (aapl)" matches as read.
          (tx) =>
              tx.displayName.toLowerCase().contains(q) ||
              tx.tradeId.toLowerCase().contains(q) ||
              tx.transactionType.toLowerCase().contains(q) ||
              // An all-punctuation query strips to '' — which every string
              // contains — so the figures are only consulted for real input.
              (qNum.isNotEmpty &&
                  (tx.quantity.toInt().toString().contains(qNum) ||
                      tx.unitPrice.toStringAsFixed(2).contains(qNum) ||
                      tx.commissionEarned.toStringAsFixed(2).contains(qNum) ||
                      tx.transactionAmount.toStringAsFixed(2).contains(qNum))),
        )
        .toList();
  }

  return sorted..sort(_comparatorFor(field, descending: descending));
});
