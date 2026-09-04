import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/real_time/domain/models/real_time_account.dart';
import 'package:finhub/features/real_time/domain/models/real_time_account_page.dart';
import 'package:finhub/features/real_time/domain/real_time_repository.dart';

/// [RealTimeRepository] backed by `assets/mock-data/accounts/list.json` — the
/// same account list the Accounts tab reads, offered here as the picker that
/// opens the real-time view.
class RealTimeMockRepository implements RealTimeRepository {
  /// Creates the repository over [_source], scoped to [_scope]'s advisor.
  RealTimeMockRepository(this._source, this._scope);

  final MockDataSource _source;
  final DataScope _scope;

  @override
  Future<RealTimeAccountPage> getAccounts({String? cursor, String? search}) async {
    final all = await _source.listScoped('accounts/list.json', _scope.advisorId);
    final rows = searchRows(all, search, ['accountName', 'accountNumber']);

    // Everything comes back on the first page — there is no cursor to hand
    // back, so the picker simply stops paging.
    return RealTimeAccountPage(
      accounts: rows.map(RealTimeAccount.fromApiJson).toList(),
      nextCursor: null,
      totalCount: rows.length,
    );
  }
}
