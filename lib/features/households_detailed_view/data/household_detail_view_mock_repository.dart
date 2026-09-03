import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/households_detailed_view/domain/household_detail_view_repository.dart';
import 'package:finhub/features/households_detailed_view/domain/models/household_detail_view.dart';

/// [HouseholdDetailViewRepository] backed by `assets/mock-data/households/`.
///
/// The detail screen needs four records — the household, its allocation, its
/// member accounts and its transactions — each keyed by household id in its
/// own file.
class HouseholdDetailViewMockRepository implements HouseholdDetailViewRepository {
  /// Creates the repository over [_source], scoped to [_scope]'s advisor.
  HouseholdDetailViewMockRepository(this._source, this._scope);

  final MockDataSource _source;
  final DataScope _scope;

  @override
  Future<HouseholdDetailView> getHouseholdDetail(String householdId) async {
    // A leadership user with no advisor selected fails here rather than
    // silently returning a household from someone else's book.
    if (!_scope.isResolved) throw const NotFoundError();

    final household = await _source.readScoped('households/detail.json', householdId);
    if (household == null) throw const NotFoundError();

    return HouseholdDetailView.fromApiJson(
      householdJson: household,
      allocationList: await _source.listScoped('households/allocation.json', householdId),
      accountList: await _source.listScoped('households/accounts.json', householdId),
      transactionList: await _source.listScoped('households/transactions.json', householdId),
    );
  }
}
