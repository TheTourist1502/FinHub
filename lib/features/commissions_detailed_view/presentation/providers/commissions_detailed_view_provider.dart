import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/commissions_detailed_view/data/commissions_detailed_view_mock_repository.dart';
import 'package:finhub/features/commissions_detailed_view/domain/commissions_detailed_view_repository.dart';
import 'package:finhub/features/commissions_detailed_view/domain/models/commission_detail_transaction_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// Provides the concrete [CommissionsDetailedViewRepository] implementation.
final commissionDetailedViewRepositoryProvider = Provider<CommissionsDetailedViewRepository>(
  (ref) => CommissionsDetailedViewMockRepository(ref.watch(mockDataSourceProvider), ref.watch(dataScopeProvider)),
);

/// Fetches the commission transactions for [accountId].
///
/// Keyed by account ID so each unique ID maintains its own cache entry.
///
/// The repository is watched, not read: `dataScopeProvider` rebuilds it when a
/// leadership user selects a different advisor, so every cached entry here goes
/// stale at that moment rather than serving the previous advisor's commissions.
final FutureProviderFamily<List<CommissionDetailTransactionCard>, String> commissionDetailedViewProvider =
    FutureProvider.family<List<CommissionDetailTransactionCard>, String>(
      (ref, accountId) =>
          ref.watch(commissionDetailedViewRepositoryProvider).getCommissionDetailsByAccountId(accountId),
    );
