import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_transaction.dart';
import 'package:finhub/shared/widgets/transaction/transaction_search.dart';

/// One rendered row of the transactions tab: an activity plus the date header
/// to draw above it, or `null` when the row continues the previous group.
class RealTimeTransactionRowData {
  /// Creates a [RealTimeTransactionRowData].
  const RealTimeTransactionRowData({required this.transaction, this.dateHeader});

  /// The activity shown by this row.
  final RealTimeTransaction transaction;

  /// Group header text, set only on the first row of each snapshot group.
  final String? dateHeader;
}

/// Filters [transactions] by [query], sorts them by trade price, and flattens
/// them into rows grouped by the snapshot header returned by [dateHeaderOf].
///
/// Groups appear in the order their first activity appears in the sorted list,
/// so the sort order is never disturbed by grouping.
///
/// [dateHeaderOf] returns `null` for an activity whose snapshot timestamp is
/// missing; those activities form their own group that renders with no header
/// at all rather than a placeholder one.
List<RealTimeTransactionRowData> buildRealTimeTransactionRows({
  required List<RealTimeTransaction> transactions,
  required String query,
  required bool sortDescending,
  required String? Function(RealTimeTransaction transaction) dateHeaderOf,
}) {
  final trimmed = query.toLowerCase();
  final sorted =
      (trimmed.isEmpty
            ? [...transactions]
            : transactions
                  .where(
                    (t) => transactionMatchesSearch(
                      query: trimmed,
                      securityName: t.accountActivityDescription,
                      tickerSymbol: t.tickerSymbol ?? '',
                      transactionId: '',
                      accountName: '',
                      accountType: '',
                      assetClass: '',
                      transactionType: t.accountActivity,
                    ),
                  )
                  .toList())
        ..sort(
          (a, b) => sortDescending
              ? b.tradePriceInBaseCurrency.compareTo(a.tradePriceInBaseCurrency)
              : a.tradePriceInBaseCurrency.compareTo(b.tradePriceInBaseCurrency),
        );

  // Groups keep insertion order, so the sorted order survives the flattening.
  final groups = <String?, List<RealTimeTransaction>>{};
  for (final t in sorted) {
    (groups[dateHeaderOf(t)] ??= []).add(t);
  }

  return [
    for (final entry in groups.entries)
      for (var i = 0; i < entry.value.length; i++)
        RealTimeTransactionRowData(
          transaction: entry.value[i],
          dateHeader: i == 0 ? entry.key : null,
        ),
  ];
}
