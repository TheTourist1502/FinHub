import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/utils/date_sort_utils.dart';
import 'package:finhub/features/account_detail_view/domain/account_detail_repository.dart';
import 'package:finhub/features/account_detail_view/domain/models/account_aum_trend.dart';
import 'package:finhub/features/account_detail_view/domain/models/detailed_account.dart';

/// [AccountDetailRepository] backed by `assets/mock-data/accounts/`.
///
/// The detail screen needs four records — the account, its allocation, its
/// transactions and its positions — each keyed by account id in its own file.
class AccountDetailMockRepository implements AccountDetailRepository {
  /// Creates the repository over [_source], scoped to [_scope]'s advisor.
  AccountDetailMockRepository(this._source, this._scope);

  final MockDataSource _source;
  final DataScope _scope;

  @override
  Future<DetailedAccount> getDetailedAccount(String accountId) async {
    // A leadership user with no advisor selected fails here rather than
    // silently returning an account from someone else's book.
    if (!_scope.isResolved) throw const NotFoundError();

    // Four records, each keyed by account id in its own file.
    final account = await _source.readScoped('accounts/detail.json', accountId);
    if (account == null) throw const NotFoundError();

    return DetailedAccount.fromApiJson(
      accountJson: account,
      allocationList: await _source.listScoped('accounts/allocation.json', accountId),
      transactionList: await _source.listScoped('accounts/transactions.json', accountId),
      positionList: await _source.listScoped('accounts/positions.json', accountId),
    );
  }

  @override
  Future<List<AccountAumTrend>> getAccountsAumTrends(String accountId) async {
    final rows = await _source.listScoped('accounts/aum_history.json', accountId);
    return rows.map(AccountAumTrend.fromApiJson).toList()..sort((a, b) => compareDatesAsc(a.weekDate, b.weekDate));
  }
}
