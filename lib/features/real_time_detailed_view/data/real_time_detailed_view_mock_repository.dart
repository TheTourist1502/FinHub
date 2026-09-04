import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_position.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_transaction.dart';
import 'package:finhub/features/real_time_detailed_view/domain/real_time_detailed_view_repository.dart';

/// [RealTimeDetailedViewRepository] backed by `assets/mock-data/real_time/`.
///
/// Positions and activity are keyed directly by account id in `holdings.json`
/// and `activities.json` — the account was already picked from the advisor's
/// own book on the selection screen, so no further advisor key is needed to
/// find the record; [_scope] only guards against an unresolved leadership
/// selection reaching either fixture through a direct link.
class RealTimeDetailedViewMockRepository implements RealTimeDetailedViewRepository {
  /// Creates the repository over [_source], scoped to [_scope]'s advisor.
  RealTimeDetailedViewMockRepository(this._source, this._scope);

  final MockDataSource _source;
  final DataScope _scope;

  @override
  Future<List<RealTimePosition>> getPositions(String accountId) async {
    // A leadership user with no advisor selected fails here rather than
    // silently returning positions for an account from someone else's book.
    if (!_scope.isResolved) throw const NotFoundError();

    final body = await _source.readScoped('real_time/holdings.json', accountId);
    if (body == null) throw const NotFoundError();
    return (body['holdings'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(RealTimePosition.fromApiJson)
        .toList();
  }

  @override
  Future<List<RealTimeTransaction>> getTransactions(String accountId) async {
    if (!_scope.isResolved) throw const NotFoundError();

    final body = await _source.readScoped('real_time/activities.json', accountId);
    if (body == null) throw const NotFoundError();
    // The snapshot's "as of" stamp lives on the envelope rather than on each
    // row, so it is folded in before parsing.
    final asOfDate = body['asOfDate'];
    return (body['activities'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((activity) => {...activity, 'asOfDate': asOfDate})
        .map(RealTimeTransaction.fromApiJson)
        .toList();
  }
}
