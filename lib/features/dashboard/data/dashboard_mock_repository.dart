import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/utils/date_sort_utils.dart';
import 'package:finhub/features/dashboard/domain/dashboard_repository.dart';
import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:finhub/features/personalize/domain/personalize_repository.dart';

/// [DashboardRepository] backed by `assets/mock-data/dashboard/` and
/// `assets/mock-data/commissions/`.
///
/// Serves both roles from one implementation: [_scope] names the advisor whose
/// book to read — their own for an advisor, the selected one for a leadership
/// user. Nothing above this class knows the difference.
class DashboardMockRepository implements DashboardRepository {
  /// Creates the repository over [_source], scoped to [_scope]'s advisor.
  DashboardMockRepository(this._source, this._personalizeRepo, this._scope);

  final MockDataSource _source;
  final IPersonalizeRepository _personalizeRepo;
  final DataScope _scope;

  @override
  Future<DashboardSummary> getDashboardSummary() async =>
      DashboardSummary.fromApiJson(await _source.readScoped('dashboard/summary.json', _scope.advisorId) ?? const {});

  @override
  Future<List<FaCommissionEntry>> getCommissionHistory() async {
    final rows = await _source.listScoped('commissions/history.json', _scope.advisorId);
    return rows.map(FaCommissionEntry.fromApiJson).toList()..sort((a, b) => compareDatesAsc(a.weekDate, b.weekDate));
  }

  @override
  Future<List<CommissionSummaryEntry>> getCommissionSummary() async {
    final rows = await _source.listScoped('commissions/summary.json', _scope.advisorId);
    return rows.map(CommissionSummaryEntry.fromApiJson).toList();
  }

  @override
  Future<List<FaAumEntry>> getFaAumHistory() async {
    final rows = await _source.listScoped('dashboard/aum_history.json', _scope.advisorId);
    return rows.map(FaAumEntry.fromApiJson).toList()..sort((a, b) => compareDatesAsc(a.weekDate, b.weekDate));
  }

  @override
  Future<List<AssetAllocation>> getFaAssetAllocations() async {
    final rows = await _source.listScoped('dashboard/asset_allocation.json', _scope.advisorId);
    return rows.map(AssetAllocation.fromApiJson).toList();
  }

  @override
  Future<List<HouseholdInsight>> getHouseholds() async {
    final rows = await _source.listScoped('dashboard/household_insights.json', _scope.advisorId);
    return rows.map(HouseholdInsight.fromApiJson).toList();
  }

  /// The dashboard's quick actions are the first three enabled entries of the
  /// user's personalization settings — derived, not stored separately.
  @override
  Future<List<QuickAction>> getDashboardQuickActions() async {
    final data = await _personalizeRepo.getPersonalizeOptions();
    final enabled = data.quickActions.where((a) => a.isEnabled).toList()..sort((a, b) => a.order.compareTo(b.order));
    final trimmed = enabled.length > 3 ? enabled.sublist(0, 3) : enabled;
    return trimmed.map((a) => QuickAction(id: a.quickActionKey, label: a.label, icon: a.quickActionKey)).toList();
  }

  @override
  Future<List<RecentTransaction>> getRecentTransactions() async {
    final rows = await _source.listScoped('dashboard/recent_transactions.json', _scope.advisorId);
    return rows.map(RecentTransaction.fromApiJson).toList()
      ..sort((a, b) => compareDatesDesc(a.transactionDate, b.transactionDate));
  }
}
