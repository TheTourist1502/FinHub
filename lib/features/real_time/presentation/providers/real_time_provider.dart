import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/real_time/data/real_time_mock_repository.dart';
import 'package:finhub/features/real_time/domain/models/real_time_account_list_state.dart';
import 'package:finhub/features/real_time/domain/real_time_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the concrete [RealTimeRepository] implementation.
final realTimeRepositoryProvider = Provider<RealTimeRepository>(
  (ref) => RealTimeMockRepository(ref.watch(mockDataSourceProvider), ref.watch(dataScopeProvider)),
);

/// Manages the full lifecycle of the real-time account picker's list:
/// initial load, cursor-based pagination, and search.
///
/// The state is [AsyncValue<RealTimeAccountListState>]:
/// - [AsyncLoading] — initial fetch in progress (shows the picker's spinner).
/// - [AsyncError]   — initial fetch failed.
/// - [AsyncData]    — at least one page loaded; further pagination is tracked
///                    inside [RealTimeAccountListState] via [RealTimeAccountListState.isLoadingMore].
final realTimeAccountsNotifierProvider = AsyncNotifierProvider<RealTimeAccountsNotifier, RealTimeAccountListState>(
  RealTimeAccountsNotifier.new,
);

/// Notifier that drives cursor-based pagination and search for the real-time
/// account picker's `AppSingleSelect`.
class RealTimeAccountsNotifier extends AsyncNotifier<RealTimeAccountListState> {
  /// Search term applied to the current [state]; `''` means unfiltered.
  ///
  /// Kept out of the state model itself since it isn't rendered — only used
  /// to pass along to [loadMore] so pagination stays scoped to the active
  /// search.
  String _search = '';

  @override
  Future<RealTimeAccountListState> build() async {
    final page = await ref.watch(realTimeRepositoryProvider).getAccounts();
    return RealTimeAccountListState(
      accounts: page.accounts,
      totalCount: page.totalCount,
      nextCursor: page.nextCursor,
      // The first unfiltered response decides the mode: a cursor means more
      // pages exist, so search and pagination go to the repository. No cursor
      // means the whole dataset is already in memory and the picker filters
      // locally — see [RealTimeAccountListState.shouldLazyLoadData].
      shouldLazyLoadData: !page.isCompleteDataset,
    );
  }

  /// Fetches the next page and appends it to [RealTimeAccountListState.accounts].
  ///
  /// Guards against concurrent calls and end-of-list by checking
  /// [RealTimeAccountListState.isLoadingMore] and [RealTimeAccountListState.hasMore]
  /// before issuing a request. Safe to call from scroll listeners on every
  /// frame — duplicate invocations are no-ops.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true, clearPaginationError: true));

    try {
      final page = await ref.read(realTimeRepositoryProvider).getAccounts(cursor: current.nextCursor, search: _search);

      state = AsyncData(
        RealTimeAccountListState(
          accounts: [...current.accounts, ...page.accounts],
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
          shouldLazyLoadData: current.shouldLazyLoadData,
        ),
      );
    } on AppError catch (e, s) {
      AppLogger.e('RealTimeAccountsNotifier.loadMore failed', e, s);
      state = AsyncData(current.copyWith(isLoadingMore: false, paginationError: e));
    } on Object catch (e, s) {
      AppLogger.e('RealTimeAccountsNotifier.loadMore unexpected error', e, s);
      state = AsyncData(
        current.copyWith(isLoadingMore: false, paginationError: const UnknownError()),
      );
    }
  }

  /// Discards all loaded pages and re-fetches the first, unfiltered page.
  ///
  /// Called from the account-selection screen's [RefreshIndicator]. Resets to
  /// a loading state before fetching so the full-screen shimmer shows during
  /// the refresh, then replaces the state with the fresh page on success or
  /// an error on failure — the same loading→data/error path as [build].
  /// Clears any active search term, since the picker's search field is itself
  /// reset every time the sheet is reopened.
  Future<void> refresh() async {
    _search = '';
    state = const AsyncValue.loading();

    try {
      final page = await ref.read(realTimeRepositoryProvider).getAccounts();

      state = AsyncData(
        RealTimeAccountListState(
          accounts: page.accounts,
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
          // Safe to re-decide: the search term was just cleared, so this
          // response describes the whole dataset the same way `build`'s did.
          shouldLazyLoadData: !page.isCompleteDataset,
        ),
      );
    } on AppError catch (e, s) {
      AppLogger.e('RealTimeAccountsNotifier.refresh failed', e, s);
      state = AsyncError(e, s);
    } on Object catch (e, s) {
      AppLogger.e('RealTimeAccountsNotifier.refresh unexpected error', e, s);
      state = AsyncError(e, s);
    }
  }

  /// Re-fetches the first page filtered by [query] (matched against account
  /// number and account name), discarding any accumulated pages from the
  /// previous search term.
  ///
  /// Called (already debounced by the picker's search field) as the advisor
  /// types. Preserves the existing list during the fetch so the sheet is
  /// never blanked mid-search; on failure the previous list is retained and
  /// [RealTimeAccountListState.paginationError] is set.
  ///
  /// No-op in client mode — the whole dataset is already in memory, so the
  /// picker filters its own options and never calls this.
  Future<void> search(String query) async {
    final current = state.value;
    if (current == null || !current.shouldLazyLoadData) return;

    _search = query;
    state = AsyncData(current.copyWith(isLoadingMore: true, clearPaginationError: true));

    try {
      final page = await ref.read(realTimeRepositoryProvider).getAccounts(search: query);

      state = AsyncData(
        RealTimeAccountListState(
          accounts: page.accounts,
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
          shouldLazyLoadData: current.shouldLazyLoadData,
        ),
      );
    } on AppError catch (e, s) {
      AppLogger.e('RealTimeAccountsNotifier.search failed', e, s);
      state = AsyncData(current.copyWith(isLoadingMore: false, paginationError: e));
    } on Object catch (e, s) {
      AppLogger.e('RealTimeAccountsNotifier.search unexpected error', e, s);
      state = AsyncData(
        current.copyWith(isLoadingMore: false, paginationError: const UnknownError()),
      );
    }
  }
}
