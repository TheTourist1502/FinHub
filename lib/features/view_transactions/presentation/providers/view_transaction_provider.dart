import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/core/utils/date_sort_utils.dart';
import 'package:finhub/features/view_transactions/data/view_transactions_mock_repository.dart';
import 'package:finhub/features/view_transactions/domain/models/view_transaction.dart';
import 'package:finhub/features/view_transactions/domain/models/view_transactions_response.dart';
import 'package:finhub/features/view_transactions/domain/view_transactions_repository.dart';
import 'package:finhub/shared/widgets/transaction/transaction_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------

/// Provides the active [IViewTransactionsRepository] implementation.
///
/// Override with a fake in widget/unit tests to avoid network calls.
final Provider<IViewTransactionsRepository> viewTransactionsRepositoryProvider = Provider<IViewTransactionsRepository>(
  (ref) => ViewTransactionsMockRepository(ref.watch(mockDataSourceProvider), ref.watch(dataScopeProvider)),
);

// ---------------------------------------------------------------------------
// Core notifier
// ---------------------------------------------------------------------------

/// Manages the full lifecycle of the transaction history list:
/// initial load, cursor-based pagination, and pull-to-refresh.
///
/// The state is [AsyncValue<TransactionListState>]:
/// - [AsyncLoading] — initial fetch in progress (shows shimmer).
/// - [AsyncError]   — initial fetch failed (shows full-screen error + retry).
/// - [AsyncData]    — at least one page loaded; further pagination is tracked
///                    inside [TransactionListState] via [isLoadingMore] and
///                    [paginationError].
final AsyncNotifierProvider<ViewTransactionsNotifier, TransactionListState> viewTransactionsNotifierProvider =
    AsyncNotifierProvider<ViewTransactionsNotifier, TransactionListState>(
      ViewTransactionsNotifier.new,
    );

/// Notifier that drives cursor-based pagination for the transaction history.
class ViewTransactionsNotifier extends AsyncNotifier<TransactionListState> {
  @override
  Future<TransactionListState> build() async {
    final page = await ref.watch(viewTransactionsRepositoryProvider).getTransactions();
    return TransactionListState(
      transactions: page.transactions,
      totalCount: page.totalCount,
      nextCursor: page.nextCursor,
    );
  }

  /// Fetches the next page and appends it to [TransactionListState.transactions].
  ///
  /// Guards against concurrent calls and end-of-list by checking
  /// [isLoadingMore] and [hasMore] before issuing a request. Safe to call
  /// from scroll listeners on every frame — duplicate invocations are no-ops.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true, clearPaginationError: true));

    try {
      final page = await ref.read(viewTransactionsRepositoryProvider).getTransactions(cursor: current.nextCursor);

      state = AsyncData(
        TransactionListState(
          transactions: [...current.transactions, ...page.transactions],
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
        ),
      );
    } on AppError catch (e, s) {
      AppLogger.e('ViewTransactionsNotifier.loadMore failed', e, s);
      state = AsyncData(current.copyWith(isLoadingMore: false, paginationError: e));
    } on Object catch (e, s) {
      AppLogger.e('ViewTransactionsNotifier.loadMore unexpected error', e, s);
      state = AsyncData(
        current.copyWith(isLoadingMore: false, paginationError: const UnknownError()),
      );
    }
  }

  /// Discards all loaded pages and re-fetches from the first page.
  ///
  /// Called from the [RefreshIndicator]. Resets to a loading state before
  /// fetching so the full-screen shimmer (search field, header row, and
  /// list) shows during the refresh, then replaces the state with the fresh
  /// page on success or an error on failure — the same loading→data/error
  /// path as [build].
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    try {
      final page = await ref.read(viewTransactionsRepositoryProvider).getTransactions();

      state = AsyncData(
        TransactionListState(
          transactions: page.transactions,
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
        ),
      );
    } on AppError catch (e, s) {
      AppLogger.e('ViewTransactionsNotifier.refresh failed', e, s);
      state = AsyncError(e, s);
    } on Object catch (e, s) {
      AppLogger.e('ViewTransactionsNotifier.refresh unexpected error', e, s);
      state = AsyncError(e, s);
    }
  }
}

// ---------------------------------------------------------------------------
// UI state providers
// ---------------------------------------------------------------------------

/// Manages the live search query on the transaction history screen.
final NotifierProvider<ViewTransactionSearchNotifier, String> viewTransactionSearchProvider =
    NotifierProvider<ViewTransactionSearchNotifier, String>(ViewTransactionSearchNotifier.new);

/// Holds the current search query for the transaction history screen.
class ViewTransactionSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  /// Returns the current query string.
  String get query => state;

  /// Updates the query and rebuilds all dependents.
  set query(String q) => state = q;
}

/// Holds the active trade / non-trade chip selection for the transaction
/// history screen.
class ViewTransactionFilterNotifier extends Notifier<TransactionFilter> {
  @override
  TransactionFilter build() => TransactionFilter.all;

  // Write-only state — callers set the filter; reads go through the provider.
  // ignore: avoid_setters_without_getters
  set filter(TransactionFilter value) => state = value;
}

/// Provider for the transaction list type filter (All / Trade / Non-Trade).
final NotifierProvider<ViewTransactionFilterNotifier, TransactionFilter> viewTransactionFilterProvider =
    NotifierProvider<ViewTransactionFilterNotifier, TransactionFilter>(ViewTransactionFilterNotifier.new);

/// Stores the active sort field for the transaction list (`'date'`, `'amount'`, or `'account'`).
class ViewTransactionSortFieldNotifier extends Notifier<String> {
  @override
  String build() => 'date';

  // Write-only state — callers set the field; reads go through the provider.
  // ignore: avoid_setters_without_getters
  set field(String value) => state = value;
}

/// Provider for the transaction list sort field.
final NotifierProvider<ViewTransactionSortFieldNotifier, String> viewTransactionSortFieldProvider =
    NotifierProvider<ViewTransactionSortFieldNotifier, String>(ViewTransactionSortFieldNotifier.new);

/// Stores the sort direction: `true` = descending (newest / largest first).
class ViewTransactionSortNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  // Write-only state — callers set the direction; reads go through the provider.
  // ignore: avoid_setters_without_getters
  set descending(bool value) => state = value;
}

/// Provider for the transaction list sort direction.
final NotifierProvider<ViewTransactionSortNotifier, bool> viewTransactionSortDescendingProvider =
    NotifierProvider<ViewTransactionSortNotifier, bool>(ViewTransactionSortNotifier.new);

// ---------------------------------------------------------------------------
// Derived — filtered + sorted list
// ---------------------------------------------------------------------------

/// Returns [AsyncValue<List<Transaction>>] derived from the accumulated list
/// inside [viewTransactionsNotifierProvider], filtered by
/// [viewTransactionSearchProvider] and sorted by
/// [viewTransactionSortAscendingProvider].
///
/// Consumers use `async.when(loading: ..., error: ..., data: ...)` for the
/// initial-load gate; the pagination state is read directly from
/// [viewTransactionsNotifierProvider].
final Provider<AsyncValue<List<Transaction>>> filteredViewTransactionsProvider =
    Provider.autoDispose<AsyncValue<List<Transaction>>>((ref) {
      final async = ref.watch(viewTransactionsNotifierProvider);
      final query = ref.watch(viewTransactionSearchProvider).trim().toLowerCase();
      final filter = ref.watch(viewTransactionFilterProvider);
      final sortField = ref.watch(viewTransactionSortFieldProvider);
      final descending = ref.watch(viewTransactionSortDescendingProvider);

      return async.whenData((listState) {
        var result = listState.transactions;

        // Filtering runs over the pages loaded so far — pagination is
        // cursor-based and the server has no type parameter, so a narrow
        // filter fills in as the user keeps scrolling.
        if (filter != TransactionFilter.all) {
          result = result.where((t) => filter.matches(t.transactionType)).toList();
        }

        if (query.isNotEmpty) {
          result = result.where((t) {
            return t.securityName.toLowerCase().contains(query) ||
                (t.tickerSymbol ?? '').toLowerCase().contains(query) ||
                t.accountName.toLowerCase().contains(query) ||
                t.transactionType.toLowerCase().contains(query) ||
                t.accountType.toLowerCase().contains(query) ||
                (t.assetClass ?? '').toLowerCase().contains(query);
          }).toList();
        }

        return [...result]..sort((a, b) {
          switch (sortField) {
            // Ordered numerically on `displayAmount` — the same figure the
            // card renders behind its `$`.
            case 'amount':
              return descending
                  ? b.displayAmount.compareTo(a.displayAmount)
                  : a.displayAmount.compareTo(b.displayAmount);
            case 'account':
              return descending ? b.accountName.compareTo(a.accountName) : a.accountName.compareTo(b.accountName);
            // Undated rows sort last in both directions — see
            // `compareDates` — so "no trade date" never reads as the
            // newest or the oldest record.
            default:
              return compareDates(a.transactionDate, b.transactionDate, descending: descending);
          }
        });
      });
    });
