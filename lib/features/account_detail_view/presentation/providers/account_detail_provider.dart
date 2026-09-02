import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/account_detail_view/data/account_detail_mock_repository.dart';
import 'package:finhub/features/account_detail_view/domain/account_detail_repository.dart';
import 'package:finhub/features/account_detail_view/domain/models/account_aum_trend.dart';
import 'package:finhub/features/account_detail_view/domain/models/detailed_account.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the concrete [AccountDetailRepository] implementation.
final accountDetailRepositoryProvider = Provider<AccountDetailRepository>(
  (ref) => AccountDetailMockRepository(ref.watch(mockDataSourceProvider), ref.watch(dataScopeProvider)),
);

/// Loads the full detail of a single account identified by [accountId].
///
/// The repository is watched, not read: `dataScopeProvider` rebuilds it when a
/// leadership user selects a different advisor, so every cached entry here goes
/// stale at that moment rather than serving the previous advisor's account.
// ignore: specify_nonobvious_property_types
final detailedAccountProvider = FutureProvider.family<DetailedAccount, String>(
  (ref, accountId) => ref.watch(accountDetailRepositoryProvider).getDetailedAccount(accountId),
);

/// Loads the weekly AUM trend history of a single account identified by [accountId].
///
/// Watches the repository for the same reason as [detailedAccountProvider].
// ignore: specify_nonobvious_property_types
final accountAumTrendsProvider = FutureProvider.family<List<AccountAumTrend>, String>(
  (ref, accountId) => ref.watch(accountDetailRepositoryProvider).getAccountsAumTrends(accountId),
);

/// Per-account cache backing [accountAumTrendFilterProviderFor] — created
/// lazily so each account gets its own independent [DashboardFilterNotifier]
/// instance, distinct from the dashboard's own filter providers and from
/// every other account's, instead of one filter selection shared globally
/// across every account detail screen.
final _accountAumTrendFilterProviders = <String, NotifierProvider<DashboardFilterNotifier, DashboardFilter>>{};

/// Returns the [NotifierProvider] holding the currently selected time-range
/// filter for [accountId]'s AUM trend chart.
///
/// Scoped per account (rather than one shared provider) so navigating from
/// one account's detail screen to another's doesn't carry over the first
/// account's filter selection — e.g. leaving a long-history account on
/// "YTD" and opening a newer account whose data doesn't support YTD.
NotifierProvider<DashboardFilterNotifier, DashboardFilter> accountAumTrendFilterProviderFor(String accountId) {
  return _accountAumTrendFilterProviders.putIfAbsent(
    accountId,
    () => NotifierProvider<DashboardFilterNotifier, DashboardFilter>(DashboardFilterNotifier.new),
  );
}
