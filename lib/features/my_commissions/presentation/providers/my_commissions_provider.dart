import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:finhub/features/my_commissions/data/my_commissions_mock_repository.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_data.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_summary.dart';
import 'package:finhub/features/my_commissions/domain/my_commissions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the concrete [MyCommissionsRepository] implementation.
final myCommissionsRepositoryProvider = Provider<MyCommissionsRepository>(
  (ref) => MyCommissionsMockRepository(ref.watch(mockDataSourceProvider), ref.watch(dataScopeProvider)),
);

/// Loads the commission summary (stats, top accounts) for the authenticated
/// advisor.
///
/// The commissions trend is sourced from [commissionHistoryProvider] — already
/// fetched by the dashboard — instead of issuing a second
/// `GET /v1/commissions/history` request.
///
/// Transaction-level records are not included — see
/// [commissionsDetailsNotifierProvider] for the paginated Details tab data.
///
/// Auto-disposes when no longer listened to.
// ignore: specify_nonobvious_property_types
final myCommissionsProvider = FutureProvider.autoDispose<CommissionData>((ref) async {
  final data = await ref.watch(myCommissionsRepositoryProvider).getMyCommissionsData();
  final history = await ref.watch(commissionHistoryProvider.future);

  return CommissionData(
    commissionEarned: data.commissionEarned,
    householdsContributing: data.householdsContributing,
    accountsContributing: data.accountsContributing,
    commissionsTrend: history,
    topAccounts: data.topAccounts,
  );
});

/// Drives cursor-based pagination for the Details tab's commission
/// transaction list.
///
/// Auto-disposes when no longer listened to.
// ignore: specify_nonobvious_property_types
final commissionsDetailsNotifierProvider =
    AsyncNotifierProvider.autoDispose<CommissionsDetailsNotifier, CommissionTransactionsListState>(
      CommissionsDetailsNotifier.new,
    );

/// Notifier that drives cursor-based pagination for the commissions details list.
class CommissionsDetailsNotifier extends AsyncNotifier<CommissionTransactionsListState> {
  /// Generation counter for in-flight requests.
  ///
  /// A dependency change (notably a leadership user switching advisor) re-runs
  /// [build] on the *same* notifier instance, so a page already in flight
  /// would otherwise land in the new advisor's state — showing one advisor's
  /// commissions under another's context. `autoDispose` does not help here:
  /// the Commissions screen stays mounted across a switch.
  int _requestId = 0;

  @override
  Future<CommissionTransactionsListState> build() async {
    final requestId = ++_requestId;
    final page = await ref.watch(myCommissionsRepositoryProvider).getCommissionSummary();

    // Something newer superseded this first page while it was in flight.
    // Falls through when there is nothing newer to keep.
    if (requestId != _requestId) {
      final newer = state.value;
      if (newer != null) return newer;
    }

    return CommissionTransactionsListState(
      transactions: page.transactions,
      totalCount: page.totalCount,
      nextCursor: page.nextCursor,
    );
  }

  /// Fetches the next page and appends it to
  /// [CommissionTransactionsListState.transactions].
  ///
  /// Guards against concurrent calls and end-of-list by checking
  /// [CommissionTransactionsListState.isLoadingMore] and
  /// [CommissionTransactionsListState.hasMore] before issuing a request. Safe
  /// to call from scroll listeners on every frame — duplicate invocations are
  /// no-ops.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    final requestId = _requestId;
    state = AsyncData(current.copyWith(isLoadingMore: true, clearPaginationError: true));

    try {
      final page = await ref.read(myCommissionsRepositoryProvider).getCommissionSummary(cursor: current.nextCursor);
      if (requestId != _requestId) return; // Advisor switched — drop this page.

      state = AsyncData(
        CommissionTransactionsListState(
          transactions: [...current.transactions, ...page.transactions],
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
        ),
      );
    } on AppError catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('CommissionsDetailsNotifier.loadMore failed', e, s);
      state = AsyncData(current.copyWith(isLoadingMore: false, paginationError: e));
    } on Object catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('CommissionsDetailsNotifier.loadMore unexpected error', e, s);
      state = AsyncData(
        current.copyWith(isLoadingMore: false, paginationError: const UnknownError()),
      );
    }
  }

  /// Discards all loaded pages and re-fetches from the first page.
  ///
  /// Called from the [RefreshIndicator] alongside the overview refresh.
  /// Preserves existing transactions during the fetch so the list is never
  /// blanked mid-session; on success the list is replaced with fresh data. On
  /// failure the existing list is retained and
  /// [CommissionTransactionsListState.paginationError] is set.
  Future<void> refresh() async {
    final current = state.value;

    if (current == null) {
      ref.invalidateSelf();
      await future;
      return;
    }

    final requestId = _requestId;
    try {
      final page = await ref.read(myCommissionsRepositoryProvider).getCommissionSummary();
      if (requestId != _requestId) return; // Advisor switched — drop this page.

      state = AsyncData(
        CommissionTransactionsListState(
          transactions: page.transactions,
          totalCount: page.totalCount,
          nextCursor: page.nextCursor,
        ),
      );
    } on AppError catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('CommissionsDetailsNotifier.refresh failed', e, s);
      state = AsyncData(current.copyWith(paginationError: e));
    } on Object catch (e, s) {
      if (requestId != _requestId) return;
      AppLogger.e('CommissionsDetailsNotifier.refresh unexpected error', e, s);
      state = AsyncData(
        current.copyWith(paginationError: const UnknownError()),
      );
    }
  }
}

/// The currently selected time-range filter for the Commissions Trend chart
/// on the My Commissions overview tab.
///
/// A dedicated instance of [DashboardFilterNotifier] scoped separately from
/// the dashboard's own [commissionFilterProvider] so the two selections don't
/// interfere with one another.
final myCommissionsTrendFilterProvider = NotifierProvider<DashboardFilterNotifier, DashboardFilter>(
  DashboardFilterNotifier.new,
);
