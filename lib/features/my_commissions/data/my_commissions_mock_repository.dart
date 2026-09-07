import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_data.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_summary.dart';
import 'package:finhub/features/my_commissions/domain/my_commissions_repository.dart';

/// [MyCommissionsRepository] backed by `assets/mock-data/commissions/`.
class MyCommissionsMockRepository implements MyCommissionsRepository {
  /// Creates the repository over [_source], scoped to [_scope]'s advisor.
  MyCommissionsMockRepository(this._source, this._scope);

  final MockDataSource _source;
  final DataScope _scope;

  @override
  Future<CommissionData> getMyCommissionsData() async {
    // A leadership user with no advisor selected has nothing to read — fail
    // here rather than letting `TopAccountsSummary.fromApiJson` crash on an
    // empty fallback map.
    if (!_scope.isResolved) throw const NotFoundError();

    final body = await _source.readScoped('commissions/top_accounts.json', _scope.advisorId);
    final summary = TopAccountsSummary.fromApiJson(body ?? const {});

    return CommissionData(
      commissionEarned: summary.totalCommission,
      householdsContributing: summary.householdsContributingCount,
      accountsContributing: summary.accountsContributingCount,
      commissionsTrend: const [],
      topAccounts: summary.topAccounts,
    );
  }

  @override
  Future<CommissionTransactionPage> getCommissionSummary({String? cursor}) async {
    final rows = await _source.listScoped('commissions/summary.json', _scope.advisorId);
    return CommissionTransactionPage(
      transactions: rows.map(CommissionSummary.fromApiJson).toList(),
      nextCursor: null,
      totalCount: rows.length,
    );
  }
}
