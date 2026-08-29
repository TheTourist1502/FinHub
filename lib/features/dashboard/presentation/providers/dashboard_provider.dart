import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/dashboard/data/dashboard_mock_repository.dart';
import 'package:finhub/features/dashboard/domain/dashboard_repository.dart';
import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:finhub/features/personalize/presentation/providers/personalize_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// FA identity
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------

/// Provides the active [DashboardRepository] implementation.
///
/// Override with a fake implementation in widget/unit tests to avoid
/// loading assets.
final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardMockRepository(ref.watch(mockDataSourceProvider), ref.watch(personalizeRepositoryProvider), ref.watch(dataScopeProvider)),
);

// ---------------------------------------------------------------------------
// Data providers
// ---------------------------------------------------------------------------

/// Asynchronously loads the authoritative dashboard summary (total AUM + commission).
///
/// Calls `GET /v1/dashboard/summary` via [dashboardRepositoryProvider].
final FutureProvider<DashboardSummary> dashboardSummaryProvider = FutureProvider.autoDispose<DashboardSummary>((ref) {
  return ref.watch(dashboardRepositoryProvider).getDashboardSummary();
});

/// Exposes the FA's authoritative total commission earned in USD.
///
/// Derives [DashboardSummary.totalCommission] from [dashboardSummaryProvider]
/// (`GET /v1/dashboard/summary`) — no extra network call is made.
final FutureProvider<double> commissionSummaryProvider = FutureProvider.autoDispose<double>((ref) async {
  final summary = await ref.watch(dashboardSummaryProvider.future);
  return summary.totalCommission;
});

/// Asynchronously loads the FA's weekly commission history from the live API.
///
/// Calls `GET /v1/commissions/history` via [dashboardRepositoryProvider].
/// Replaces the legacy mock-backed [faCommissionHistoryProvider] for dashboard use.
final FutureProvider<List<FaCommissionEntry>> commissionHistoryProvider =
    FutureProvider.autoDispose<List<FaCommissionEntry>>((ref) {
      return ref.watch(dashboardRepositoryProvider).getCommissionHistory();
    });

/// Asynchronously loads the FA's weekly AUM history.
///
/// Depends on [dashboardRepositoryProvider] so the data source can be
/// swapped in tests without touching this provider.
final FutureProvider<List<FaAumEntry>> faAumHistoryProvider = FutureProvider.autoDispose<List<FaAumEntry>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getFaAumHistory();
});

/// Asynchronously loads the FA's asset allocation breakdown.
final FutureProvider<List<AssetAllocation>> faAllocationsProvider = FutureProvider.autoDispose<List<AssetAllocation>>((
  ref,
) {
  return ref.watch(dashboardRepositoryProvider).getFaAssetAllocations();
});

/// Asynchronously loads household AUM insights for the authenticated FA.
final FutureProvider<List<HouseholdInsight>> householdsProvider = FutureProvider.autoDispose<List<HouseholdInsight>>((
  ref,
) {
  return ref.watch(dashboardRepositoryProvider).getHouseholds();
});

/// Asynchronously loads recent transactions across all FA accounts.
final FutureProvider<List<RecentTransaction>> recentTransactionsProvider =
    FutureProvider.autoDispose<List<RecentTransaction>>((ref) {
      return ref.watch(dashboardRepositoryProvider).getRecentTransactions();
    });

/// Asynchronously loads the ordered quick-action shortcuts for the dashboard.
final FutureProvider<List<QuickAction>> quickActionsProvider = FutureProvider.autoDispose<List<QuickAction>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getDashboardQuickActions();
});

// ---------------------------------------------------------------------------
// Filter state providers
// ---------------------------------------------------------------------------

/// Notifier that holds the selected time-range filter for a history chart.
///
/// Defaults to [DashboardFilter.ytd] on construction.
class DashboardFilterNotifier extends Notifier<DashboardFilter> {
  @override
  DashboardFilter build() => DashboardFilter.ytd;

  /// Updates the selected filter to [filter].
  void select(DashboardFilter filter) {
    if (state != filter) {
      state = filter;
    }
  }
}

/// The currently selected time-range filter for the AUM history chart.
///
/// Defaults to [DashboardFilter.ytd].
final aumFilterProvider = NotifierProvider<DashboardFilterNotifier, DashboardFilter>(
  DashboardFilterNotifier.new,
);

/// The currently selected time-range filter for the commission history chart.
///
/// Defaults to [DashboardFilter.ytd].
final commissionFilterProvider = NotifierProvider<DashboardFilterNotifier, DashboardFilter>(
  DashboardFilterNotifier.new,
);

/// Notifier that holds the index of the asset-allocation donut slice the
/// user last tapped.
///
/// Defaults to `null` (no explicit selection) on construction, in which case
/// the donut centre falls back to the highest-allocation asset class.
class AssetAllocationSelectionNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  /// Updates the selected slice index to [index].
  void select(int index) {
    if (state != index) {
      state = index;
    }
  }
}

/// The index of the asset-allocation donut slice the user last tapped.
///
/// `null` until the user taps a slice, in which case the donut centre falls
/// back to the highest-allocation asset class.
final assetAllocationSelectedIndexProvider = NotifierProvider<AssetAllocationSelectionNotifier, int?>(
  AssetAllocationSelectionNotifier.new,
);

// ---------------------------------------------------------------------------
// DashboardFilter enum
// ---------------------------------------------------------------------------

/// Time-range filter options for the AUM and commission history charts.
///
/// All four are calendar-month windows anchored at today (see
/// `chart_filter_utils.dart`'s `_rangeStart`): 1M is the 1st of the current
/// month through today, 3M/6M reach back 2/5 additional calendar months
/// (inclusive of the current one), and YTD reaches back to January 1st of
/// the current year.
enum DashboardFilter {
  /// The current calendar month, from its 1st through today.
  oneMonth,

  /// The current calendar month plus the 2 preceding it.
  threeMonths,

  /// The current calendar month plus the 5 preceding it.
  sixMonths,

  /// January 1st of the current year through today.
  ytd;

  /// Short display label shown on the filter chip.
  String get label => switch (this) {
    DashboardFilter.oneMonth => '1M',
    DashboardFilter.threeMonths => '3M',
    DashboardFilter.sixMonths => '6M',
    DashboardFilter.ytd => 'YTD',
  };
}
