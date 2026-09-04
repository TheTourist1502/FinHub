import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/real_time/presentation/providers/real_time_provider.dart';
import 'package:finhub/features/real_time_detailed_view/data/real_time_detailed_view_mock_repository.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_detailed_data.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_position.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_transaction.dart';
import 'package:finhub/features/real_time_detailed_view/domain/real_time_detailed_view_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the concrete [RealTimeDetailedViewRepository] implementation.
final realTimeDetailedViewRepositoryProvider = Provider<RealTimeDetailedViewRepository>(
  (ref) => RealTimeDetailedViewMockRepository(ref.watch(mockDataSourceProvider), ref.watch(dataScopeProvider)),
);

/// Display metadata (name, number, type) for [accountId], taken from the
/// already-loaded account list the user picked from on the selection screen.
// ignore: specify_nonobvious_property_types
final realTimeAccountProvider = FutureProvider.autoDispose.family<RealTimeDetailedData, String>((
  ref,
  accountId,
) async {
  final accountsState = await ref.watch(realTimeAccountsNotifierProvider.future);
  final account = accountsState.accounts.firstWhere((a) => a.accountId == accountId);

  return RealTimeDetailedData(
    accountId: account.accountId,
    accountName: account.accountName,
    accountNumber: account.accountNumber,
    accountType: account.accountType,
  );
});

/// Live positions for [accountId] — the Positions tab, loaded first.
// ignore: specify_nonobvious_property_types
final realTimePositionsProvider = FutureProvider.autoDispose.family<List<RealTimePosition>, String>(
  (ref, accountId) => ref.watch(realTimeDetailedViewRepositoryProvider).getPositions(accountId),
);

/// Live transactions for [accountId] — the Transactions tab.
///
/// Deliberately sequenced *after* [realTimePositionsProvider]: firing both
/// requests at once slows the first paint of the tab the user actually lands
/// on. Positions' outcome is irrelevant here (a holdings failure must not
/// block activities), only its completion is awaited — and watching it means
/// a positions refresh re-runs this fetch too.
// ignore: specify_nonobvious_property_types
final realTimeTransactionsProvider = FutureProvider.autoDispose.family<List<RealTimeTransaction>, String>((
  ref,
  accountId,
) async {
  final repository = ref.watch(realTimeDetailedViewRepositoryProvider);
  final positions = ref.watch(realTimePositionsProvider(accountId).future);
  try {
    await positions;
  } on Object {
    // Positions failing is the Positions tab's problem, not this tab's.
  }
  return repository.getTransactions(accountId);
});
