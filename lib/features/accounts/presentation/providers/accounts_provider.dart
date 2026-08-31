import 'dart:async';

import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/accounts/data/accounts_mock_repository.dart';
import 'package:finhub/features/accounts/domain/accounts_repository.dart';
import 'package:finhub/features/accounts/domain/models/account.dart';
import 'package:finhub/features/accounts/domain/models/account_list_state.dart';
import 'package:finhub/features/accounts/domain/models/account_page.dart';
import 'package:finhub/features/accounts/domain/models/account_sort_field.dart';
import 'package:finhub/features/accounts/domain/models/accounts_filter_option.dart';
import 'package:finhub/shared/models/sort_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the concrete [AccountsRepository] implementation.
final accountsRepositoryProvider = Provider<AccountsRepository>(
  (ref) => AccountsMockRepository(ref.watch(mockDataSourceProvider), ref.watch(dataScopeProvider)),
);

/// Owns the accounts list: initial load, pagination, and refresh.
final accountsNotifierProvider = AsyncNotifierProvider<AccountsNotifier, AccountListState>(
  AccountsNotifier.new,
);

/// Drives the accounts list in one of two modes.
///
/// The mode is decided by the first response and stored in
/// [AccountListState.shouldLazyLoadData]:
///
/// - **Server mode** (more than one page) — search, sort and the type filter
///   are sent as query parameters, so changing any of them re-fetches page
///   one. Extra pages arrive via [loadMore].
/// - **Client mode** (the first page *was* the whole dataset) — no further
///   request is ever sent; [filteredAccountsProvider] narrows the list in
///   memory.
///
/// Client mode is entered only on [AccountPage.isCompleteDataset], never on a
/// null cursor alone. Holding a partial list in memory-only mode is the worst
/// of both: the filter is never sent, so the chips narrow a fraction of the
/// records and the header counts that fraction instead of the real total.
///
/// The criteria providers are observed with `ref.listen`, not `ref.watch`,
/// because `ref.watch` would re-fetch on every change and make client mode
/// impossible.
class AccountsNotifier extends AsyncNotifier<AccountListState> {
  /// Generation counter for in-flight requests.
  ///
  /// Any request ignores its own response if this number changed while it was
  /// waiting, so a slow request can't overwrite a newer one. Bumped by
  /// [build] as well as [_reload]: a dependency change (notably an advisor
  /// switch) re-runs `build` on the *same* notifier instance, so without that
  /// bump a page already in flight would land in the new advisor's state.
  int _requestId = 0;

  @override
  Future<AccountListState> build() async {
    final requestId = ++_requestId;

    // Watched, not read: `dataScopeProvider` rebuilds the repository whenever a
    // leadership user selects a different advisor, and this rebuilds with it.
    // Reading instead would leave the previous advisor's accounts on screen,
    // and tapping one would send that account ID alongside the newly selected
    // advisor — which the backend rejects with 403 "Account does not belong to
    // this advisor". The `_fetchFirstPage` / `loadMore` reads below stay reads;
    // they run inside a build that this watch has already refreshed.
    ref
      ..watch(accountsRepositoryProvider)
      ..listen(accountsSearchQueryProvider, (_, _) => _onCriteriaChanged())
      ..listen(accountsSortFieldProvider, (_, _) => _onCriteriaChanged())
      ..listen(accountsSortProvider, (_, _) => _onCriteriaChanged())
      ..listen(accountsFilterProvider, (_, _) => _onCriteriaChanged());

    // Sent with the default sort but no search or filter: the mode below is
    // only meaningful for an unfiltered result set.
    final page = await _fetchFirstPage(search: '', filter: AccountsFilterOption.all);
    // A newer build or reload started while this first page was in flight;
    // keep whatever it produced rather than overwriting it with this one.
    // Falls through when there is nothing newer to keep — this page is then
    // still the best answer available.
    if (requestId != _requestId) {
      final newer = state.value;
      if (newer != null) return newer;
    }

    return AccountListState(
      accounts: page.accounts,
      totalCount: page.totalCount,
      nextCursor: page.nextCursor,
      shouldLazyLoadData: !page.isCompleteDataset,
    );
  }

  /// Requests page one using the sort the providers currently hold.
  Future<AccountPage> _fetchFirstPage({required String search, required AccountsFilterOption filter}) {
    return ref
        .read(accountsRepositoryProvider)
        .getAccounts(
          search: search,
          filter: filter,
          sortBy: ref.read(accountsSortFieldProvider),
          sortOrder: SortOrder.fromDescending(descending: ref.read(accountsSortProvider)),
        );
  }

  /// Re-fetches when the search query, sort or filter changes.
  ///
  /// Does nothing in client mode (the UI re-filters locally) or before the
  /// first load finishes — the filter chips and sort button are shimmer until
  /// then, so the user cannot have changed anything.
  void _onCriteriaChanged() {
    final current = state.value;
    if (current == null || !current.shouldLazyLoadData) return;
    unawaited(_reload());
  }

  /// Throws away the loaded pages and fetches page one again.
  Future<void> _reload() async {
    final requestId = ++_requestId;
    final shouldLazyLoadData = state.value?.shouldLazyLoadData ?? true;
    state = const AsyncValue.loading();

    try {
      final page = await _fetchFirstPage(
        search: ref.read(accountsSearchQueryProvider).trim(),
        filter: ref.read(accountsFilterProvider),
      );
      if (requestId != _requestId) return; // A newer reload started.

      state = AsyncData(
        AccountListState(
          accounts: page.accounts,
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
          shouldLazyLoadData: shouldLazyLoadData,
        ),
      );
    } on AppError catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('AccountsNotifier reload failed', e, s);
      state = AsyncError(e, s);
    } on Object catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('AccountsNotifier reload unexpected error', e, s);
      state = AsyncError(e, s);
    }
  }

  /// Fetches the next page and appends it to the list.
  ///
  /// Returns early if a request is already running or there is no next page,
  /// so it is safe to call from a scroll listener on every frame. In client
  /// mode the cursor is always `null`, so every call is a no-op.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    // The generation this page belongs to. If an advisor switch rebuilds the
    // notifier while the request is in flight, appending to `current` would
    // splice the previous advisor's accounts into the new advisor's list — and
    // tapping one would send that account ID with the new advisor's, which the
    // backend rejects with 403.
    final requestId = _requestId;
    state = AsyncData(current.copyWith(isLoadingMore: true, clearPaginationError: true));

    try {
      final page = await ref
          .read(accountsRepositoryProvider)
          .getAccounts(
            cursor: current.nextCursor,
            search: ref.read(accountsSearchQueryProvider).trim(),
            filter: ref.read(accountsFilterProvider),
            sortBy: ref.read(accountsSortFieldProvider),
            sortOrder: SortOrder.fromDescending(descending: ref.read(accountsSortProvider)),
          );
      if (requestId != _requestId) return;

      state = AsyncData(
        AccountListState(
          accounts: [...current.accounts, ...page.accounts],
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
          shouldLazyLoadData: current.shouldLazyLoadData,
        ),
      );
    } on AppError catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('AccountsNotifier.loadMore failed', e, s);
      state = AsyncData(current.copyWith(isLoadingMore: false, paginationError: e));
    } on Object catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('AccountsNotifier.loadMore unexpected error', e, s);
      state = AsyncData(
        current.copyWith(isLoadingMore: false, paginationError: const UnknownError()),
      );
    }
  }

  /// Reloads from page one for pull-to-refresh.
  ///
  /// What it asks the server for depends on the mode, because the two modes
  /// mean different things by "the loaded list":
  ///
  /// - **Client mode** — the loaded list *is* the whole dataset, and
  ///   [filteredAccountsProvider] narrows it in memory. So the refresh must be
  ///   unfiltered, whatever the user has selected. Sending the active search
  ///   and filter would replace the full list with just that subset while
  ///   leaving the mode untouched, and every later filter change would then
  ///   narrow a list that no longer contains the other options' accounts — the
  ///   user picks a different chip and the screen goes empty, with nothing to
  ///   re-fetch it because client mode never asks the server again.
  /// - **Server mode** — the server does the narrowing, so the current search
  ///   and filter go with the request.
  ///
  /// The mode is only re-decided from an unfiltered response. On a filtered one
  /// `nextCursor` describes the matches rather than the whole dataset, so
  /// trusting it would strand the list in the wrong mode.
  Future<void> refresh() async {
    final requestId = ++_requestId;
    final previous = state.value;
    state = const AsyncValue.loading();

    try {
      final isClientMode = previous != null && !previous.shouldLazyLoadData;
      final query = isClientMode ? '' : ref.read(accountsSearchQueryProvider).trim();
      final filter = isClientMode ? AccountsFilterOption.all : ref.read(accountsFilterProvider);
      final page = await _fetchFirstPage(search: query, filter: filter);
      if (requestId != _requestId) return;

      final isUnfiltered = query.isEmpty && filter == AccountsFilterOption.all;
      state = AsyncData(
        AccountListState(
          accounts: page.accounts,
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
          shouldLazyLoadData: isUnfiltered ? !page.isCompleteDataset : (previous?.shouldLazyLoadData ?? true),
        ),
      );
    } on AppError catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('AccountsNotifier.refresh failed', e, s);
      state = AsyncError(e, s);
    } on Object catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('AccountsNotifier.refresh unexpected error', e, s);
      state = AsyncError(e, s);
    }
  }
}

/// Stores the current search query.
class _SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  // ignore: avoid_setters_without_getters — write-only state; no external read needed outside Riverpod
  set query(String v) => state = v;
}

/// The accounts search text.
///
/// In server mode a change re-fetches with a `search` parameter; in client
/// mode it only re-filters the list already in memory. The UI debounces
/// writes here (see `AccountsScreen`).
final accountsSearchQueryProvider = NotifierProvider<_SearchQueryNotifier, String>(
  _SearchQueryNotifier.new,
);

/// Stores the active sort field for the accounts list.
class _AccountsSortFieldNotifier extends Notifier<AccountSortField> {
  @override
  AccountSortField build() => AccountSortField.aum;

  // Write-only state — callers set the field; reads go through the provider.
  // ignore: avoid_setters_without_getters
  set field(AccountSortField value) => state = value;
}

/// The column the accounts list is sorted by.
final accountsSortFieldProvider = NotifierProvider<_AccountsSortFieldNotifier, AccountSortField>(
  _AccountsSortFieldNotifier.new,
);

/// Stores the sort direction for the accounts list.
///
/// `true` = descending; `false` = ascending.
class _SortDescendingNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  // Write-only state — callers set the direction; reads go through the provider.
  // ignore: avoid_setters_without_getters
  set descending(bool value) => state = value;
}

/// Whether the accounts list is sorted descending.
final accountsSortProvider = NotifierProvider<_SortDescendingNotifier, bool>(
  _SortDescendingNotifier.new,
);

/// Stores the active filter selection for the accounts list.
class _FilterNotifier extends Notifier<AccountsFilterOption> {
  @override
  AccountsFilterOption build() => AccountsFilterOption.all;

  // Write-only state — callers set the filter; reads go through the provider.
  // ignore: avoid_setters_without_getters
  set filter(AccountsFilterOption v) => state = v;
}

/// The account-type filter chosen in the chip row.
final accountsFilterProvider = NotifierProvider<_FilterNotifier, AccountsFilterOption>(
  _FilterNotifier.new,
);

/// The accounts the UI should render.
///
/// In server mode the API already searched, filtered and sorted the whole
/// dataset, so the list passes through untouched — narrowing here would only
/// see the pages loaded so far, under-counting and leaving near-empty pages.
/// In client mode everything is in memory, so all three are applied here.
final filteredAccountsProvider = Provider<AsyncValue<List<Account>>>((ref) {
  final raw = ref.watch(accountsNotifierProvider);
  final sortField = ref.watch(accountsSortFieldProvider);
  final descending = ref.watch(accountsSortProvider);
  final filter = ref.watch(accountsFilterProvider);
  final query = ref.watch(accountsSearchQueryProvider).trim().toLowerCase();

  return raw.whenData((listState) {
    if (listState.shouldLazyLoadData) return listState.accounts;

    // 1. Match the query against the account's name and number.
    final matches = query.isEmpty
        ? listState.accounts
        : listState.accounts
              .where(
                (a) => a.accountName.toLowerCase().contains(query) || a.accountNumber.toLowerCase().contains(query),
              )
              .toList();

    // 2. Keep only the selected account type.
    final filtered = switch (filter) {
      AccountsFilterOption.all => matches,
      AccountsFilterOption.householdLinked => matches.where((a) => a.isHouseholdLinked).toList(),
      AccountsFilterOption.standalone => matches.where((a) => !a.isHouseholdLinked).toList(),
    };

    // 3. Sort by the selected column.
    return List.of(filtered)..sort((a, b) {
      if (sortField == AccountSortField.name) {
        return descending ? b.accountName.compareTo(a.accountName) : a.accountName.compareTo(b.accountName);
      }
      return descending ? b.currentValue.compareTo(a.currentValue) : a.currentValue.compareTo(b.currentValue);
    });
  });
});
