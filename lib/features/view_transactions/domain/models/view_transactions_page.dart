import 'package:finhub/features/view_transactions/domain/models/view_transaction.dart';

/// A single page of transactions returned by the cursor-based API.
///
/// The frontend must never generate or modify [nextCursor] — it is an opaque
/// value owned by the server. Pass it verbatim to the next
/// [IViewTransactionsRepository.getTransactions] call to fetch the next page.
class TransactionPage {
  /// Creates a [TransactionPage].
  const TransactionPage({required this.transactions, required this.nextCursor, required this.totalCount});

  /// The transactions returned in this page (up to 50 records).
  final List<Transaction> transactions;

  /// Opaque cursor to pass in the next request, or `null` when this is the
  /// last page and no further records exist.
  final String? nextCursor;

  /// Total number of transactions available on the server across all pages
  /// (the `totalCount` key in the response). Stays constant while paginating,
  /// so the UI can show it in the header without the count growing per page.
  final int totalCount;

  /// Whether a subsequent page of transactions is available.
  bool get hasMore => nextCursor != null;
}
