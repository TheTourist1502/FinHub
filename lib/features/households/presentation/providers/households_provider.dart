import 'dart:async';

import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/households/data/households_mock_repository.dart';
import 'package:finhub/features/households/domain/households_repository.dart';
import 'package:finhub/features/households/domain/models/household_detail.dart';
import 'package:finhub/features/households/domain/models/household_list_state.dart';
import 'package:finhub/features/households/domain/models/household_page.dart';
import 'package:finhub/features/households/domain/models/household_sort_field.dart';
import 'package:finhub/shared/models/sort_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the implementation of [HouseholdsRepository].
final householdsRepositoryProvider = Provider<HouseholdsRepository>((ref) {
  return HouseholdsMockRepository(ref.watch(mockDataSourceProvider), ref.watch(dataScopeProvider));
});

/// Owns the households list: initial load, pagination, and refresh.
final householdsNotifierProvider = AsyncNotifierProvider<HouseholdsNotifier, HouseholdListState>(
  HouseholdsNotifier.new,
);

/// Drives the households list in one of two modes.
///
/// The mode is decided by the first response and stored in
/// [HouseholdListState.shouldLazyLoadData]:
///
/// - **Server mode** (more than one page) — search and sort are sent as query
///   parameters, so changing either re-fetches page one. Extra pages arrive
///   via [loadMore].
/// - **Client mode** (everything fit in one page) — no further request is
///   ever sent; [filteredHouseholdsProvider] searches and sorts in memory.
///
/// The search and sort providers are observed with `ref.listen`, not
/// `ref.watch`, because `ref.watch` would re-fetch on every change and make
/// client mode impossible.
class HouseholdsNotifier extends AsyncNotifier<HouseholdListState> {
  /// Generation counter for in-flight requests.
  ///
  /// Any request ignores its own response if this number changed while it was
  /// waiting, so a slow request can't overwrite a newer one. Bumped by
  /// [build] as well as [_reload]: a dependency change (notably an advisor
  /// switch) re-runs `build` on the *same* notifier instance, so without that
  /// bump a page already in flight would land in the new advisor's state.
  int _requestId = 0;

  @override
  Future<HouseholdListState> build() async {
    final requestId = ++_requestId;
    // Watched, not read: `dataScopeProvider` rebuilds the repository whenever a
    // leadership user selects a different advisor, and this rebuilds with it.
    // Reading instead would leave the previous advisor's households on screen,
    // and opening one would send that household ID alongside the newly selected
    // advisor, which the backend rejects with 403. The `_fetchFirstPage` /
    // `loadMore` reads below stay reads; they run inside a build that this
    // watch has already refreshed.
    ref
      ..watch(householdsRepositoryProvider)
      ..listen(householdsSearchQueryProvider, (_, _) => _onCriteriaChanged())
      ..listen(householdsSortFieldProvider, (_, _) => _onCriteriaChanged())
      ..listen(householdsSortDescendingProvider, (_, _) => _onCriteriaChanged());

    // Sent with the default sort but no search: the mode below is only
    // meaningful for an unfiltered result set.
    final page = await _fetchFirstPage(search: '');
    // A newer build or reload started while this first page was in flight;
    // keep whatever it produced rather than overwriting it with this one.
    // Falls through when there is nothing newer to keep — this page is then
    // still the best answer available.
    if (requestId != _requestId) {
      final newer = state.value;
      if (newer != null) return newer;
    }

    return HouseholdListState(
      households: page.households,
      totalCount: page.totalCount,
      nextCursor: page.nextCursor,
      shouldLazyLoadData: !page.isCompleteDataset,
    );
  }

  /// Requests page one using the sort the providers currently hold.
  Future<HouseholdPage> _fetchFirstPage({required String search}) {
    return ref
        .read(householdsRepositoryProvider)
        .getHouseholds(
          search: search,
          sortBy: ref.read(householdsSortFieldProvider),
          sortOrder: SortOrder.fromDescending(descending: ref.read(householdsSortDescendingProvider)),
        );
  }

  /// Re-fetches when the search query or sort changes.
  ///
  /// Does nothing in client mode (the UI re-filters locally) or before the
  /// first load finishes — the search field and sort button are shimmer until
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
      final query = ref.read(householdsSearchQueryProvider).trim();
      final page = await _fetchFirstPage(search: query);
      if (requestId != _requestId) return; // A newer reload started.

      state = AsyncData(
        HouseholdListState(
          households: page.households,
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
          shouldLazyLoadData: shouldLazyLoadData,
        ),
      );
    } on AppError catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('HouseholdsNotifier reload failed', e, s);
      state = AsyncError(e, s);
    } on Object catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('HouseholdsNotifier reload unexpected error', e, s);
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
    // splice the previous advisor's households into the new advisor's list —
    // and opening one would send that household ID with the new advisor's,
    // which the backend rejects with 403.
    final requestId = _requestId;
    state = AsyncData(current.copyWith(isLoadingMore: true, clearPaginationError: true));

    try {
      final query = ref.read(householdsSearchQueryProvider).trim();
      final page = await ref
          .read(householdsRepositoryProvider)
          .getHouseholds(
            cursor: current.nextCursor,
            search: query,
            sortBy: ref.read(householdsSortFieldProvider),
            sortOrder: SortOrder.fromDescending(descending: ref.read(householdsSortDescendingProvider)),
          );
      if (requestId != _requestId) return;

      state = AsyncData(
        HouseholdListState(
          households: [...current.households, ...page.households],
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
          shouldLazyLoadData: current.shouldLazyLoadData,
        ),
      );
    } on AppError catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('HouseholdsNotifier.loadMore failed', e, s);
      state = AsyncData(current.copyWith(isLoadingMore: false, paginationError: e));
    } on Object catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('HouseholdsNotifier.loadMore unexpected error', e, s);
      state = AsyncData(
        current.copyWith(isLoadingMore: false, paginationError: const UnknownError()),
      );
    }
  }

  /// Reloads from page one for pull-to-refresh.
  ///
  /// In client mode the loaded list *is* the whole dataset and the UI narrows
  /// it in memory, so the refresh goes out unsearched whatever is in the search
  /// box. Sending the query would replace the full list with just its matches
  /// while leaving the mode untouched, and clearing the box afterwards would
  /// then show only those matches — client mode never asks the server again, so
  /// there would be nothing to bring the rest back. In server mode the server
  /// does the narrowing, so the query goes with the request.
  ///
  /// The mode is only re-decided from an unsearched response. With a search
  /// active, `nextCursor` describes the matches rather than the whole dataset,
  /// so trusting it would strand the list in the wrong mode.
  Future<void> refresh() async {
    final requestId = ++_requestId;
    final previous = state.value;
    state = const AsyncValue.loading();

    try {
      final isClientMode = previous != null && !previous.shouldLazyLoadData;
      final query = isClientMode ? '' : ref.read(householdsSearchQueryProvider).trim();
      final page = await _fetchFirstPage(search: query);
      if (requestId != _requestId) return;

      state = AsyncData(
        HouseholdListState(
          households: page.households,
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
          shouldLazyLoadData: query.isEmpty ? !page.isCompleteDataset : (previous?.shouldLazyLoadData ?? true),
        ),
      );
    } on AppError catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('HouseholdsNotifier.refresh failed', e, s);
      state = AsyncError(e, s);
    } on Object catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('HouseholdsNotifier.refresh unexpected error', e, s);
      state = AsyncError(e, s);
    }
  }
}

/// Stores the current households search query.
class HouseholdsSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  /// The current search query.
  String get query => state;

  /// Updates the search query.
  set query(String newQuery) => state = newQuery;
}

/// The households search text.
///
/// In server mode a change re-fetches with a `search` parameter; in client
/// mode it only re-filters the list already in memory. The UI debounces
/// writes here (see `HouseholdsShellScreen`).
final householdsSearchQueryProvider = NotifierProvider<HouseholdsSearchQuery, String>(HouseholdsSearchQuery.new);

/// Stores the active sort field for the households list.
class _HouseholdsSortFieldNotifier extends Notifier<HouseholdSortField> {
  @override
  HouseholdSortField build() => HouseholdSortField.aum;

  // Write-only state — callers set the field; reads go through the provider.
  // ignore: avoid_setters_without_getters
  set field(HouseholdSortField value) => state = value;
}

/// The column the households list is sorted by.
final householdsSortFieldProvider = NotifierProvider<_HouseholdsSortFieldNotifier, HouseholdSortField>(
  _HouseholdsSortFieldNotifier.new,
);

/// Stores the sort direction for the households list.
///
/// `true` = descending; `false` = ascending.
class _SortDescendingNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  // Write-only state — callers set the direction; reads go through the provider.
  // ignore: avoid_setters_without_getters
  set descending(bool value) => state = value;
}

/// Whether the households list is sorted descending.
final householdsSortDescendingProvider = NotifierProvider<_SortDescendingNotifier, bool>(
  _SortDescendingNotifier.new,
);

/// The households the UI should render.
///
/// In server mode the API already searched and sorted the whole dataset, so
/// the list passes through untouched — sorting here would only see the pages
/// loaded so far and could fight the server's order. In client mode
/// everything is in memory, so the search and sort are applied here.
final filteredHouseholdsProvider = Provider<AsyncValue<List<HouseholdDetail>>>((ref) {
  final householdsAsync = ref.watch(householdsNotifierProvider);
  final sortField = ref.watch(householdsSortFieldProvider);
  final descending = ref.watch(householdsSortDescendingProvider);
  final query = ref.watch(householdsSearchQueryProvider).trim().toLowerCase();

  return householdsAsync.whenData((listState) {
    if (listState.shouldLazyLoadData) return listState.households;

    // Match the query against the household's name and id.
    final matches = query.isEmpty
        ? listState.households
        : listState.households
              .where(
                (h) => h.householdName.toLowerCase().contains(query) || h.householdId.toLowerCase().contains(query),
              )
              .toList();

    return List.of(matches)..sort((a, b) {
      if (sortField == HouseholdSortField.name) {
        return descending ? b.householdName.compareTo(a.householdName) : a.householdName.compareTo(b.householdName);
      }
      return descending ? b.totalAum.compareTo(a.totalAum) : a.totalAum.compareTo(b.totalAum);
    });
  });
});
