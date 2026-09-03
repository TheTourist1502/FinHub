import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/features/view_transactions/domain/models/view_transaction.dart';

/// Immutable UI state owned by [ViewTransactionsNotifier].
///
/// Tracks the accumulated transaction list, the opaque cursor for the next
/// API page, an in-progress pagination flag, and any pagination-level error
/// that occurred after the initial load succeeded.
///
/// The initial async loading / initial error states are represented by
/// [AsyncValue] wrapping this class in the Riverpod layer; this model only
/// appears inside [AsyncData].
class TransactionListState {
  /// Creates a [TransactionListState].
  const TransactionListState({
    required this.transactions,
    required this.totalCount,
    this.nextCursor,
    this.isLoadingMore = false,
    this.paginationError,
  });

  /// All transactions accumulated across every loaded page, in server order.
  ///
  /// The presentation layer applies search filtering and date sorting over
  /// this list before rendering.
  final List<Transaction> transactions;

  /// Total number of transactions available on the server across all pages.
  ///
  /// Comes from the API's `totalCount` key and stays constant while
  /// paginating — render this in the count header instead of
  /// [transactions.length] so the number doesn't grow as pages load.
  final int totalCount;

  /// Opaque cursor to fetch the next page, or `null` when all pages are
  /// exhausted. Never modify this value — pass it verbatim to the API.
  final String? nextCursor;

  /// `true` while a pagination request is in-flight.
  ///
  /// The UI shows a bottom loading indicator and suppresses duplicate calls
  /// while this flag is set.
  final bool isLoadingMore;

  /// Non-null when the most recent pagination request failed.
  ///
  /// Cleared automatically at the start of the next [loadMore] or [refresh]
  /// attempt. The initial-load error is represented by [AsyncError], not here.
  final AppError? paginationError;

  /// Whether a subsequent page exists.
  bool get hasMore => nextCursor != null;

  /// Returns a copy of this state with selected fields replaced.
  ///
  /// Use [clearNextCursor] to set [nextCursor] to `null` (the standard
  /// `field ?? old` pattern cannot express explicit-null intent).
  /// Use [clearPaginationError] similarly for [paginationError].
  TransactionListState copyWith({
    List<Transaction>? transactions,
    int? totalCount,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? isLoadingMore,
    AppError? paginationError,
    bool clearPaginationError = false,
  }) => TransactionListState(
    transactions: transactions ?? this.transactions,
    totalCount: totalCount ?? this.totalCount,
    nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    paginationError: clearPaginationError ? null : (paginationError ?? this.paginationError),
  );
}
