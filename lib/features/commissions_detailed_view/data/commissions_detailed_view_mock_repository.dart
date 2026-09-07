import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/commissions_detailed_view/domain/commissions_detailed_view_repository.dart';
import 'package:finhub/features/commissions_detailed_view/domain/models/commission_detail_transaction_card.dart';

/// [CommissionsDetailedViewRepository] backed by
/// `assets/mock-data/commissions/details.json`, keyed by account id.
class CommissionsDetailedViewMockRepository implements CommissionsDetailedViewRepository {
  /// Creates the repository over [_source], scoped to [_scope]'s advisor.
  CommissionsDetailedViewMockRepository(this._source, this._scope);

  final MockDataSource _source;
  final DataScope _scope;

  @override
  Future<List<CommissionDetailTransactionCard>> getCommissionDetailsByAccountId(String accountId) async {
    // Reads the scope so a leadership user with no advisor selected fails here
    // rather than silently returning another advisor's commission detail.
    if (!_scope.isResolved) throw const NotFoundError();

    final rows = await _source.listScoped('commissions/details.json', accountId);
    return rows.map(CommissionDetailTransactionCard.fromJson).toList();
  }
}
