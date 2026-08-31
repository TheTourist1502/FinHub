import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/accounts/domain/accounts_repository.dart';
import 'package:finhub/features/accounts/domain/models/account.dart';
import 'package:finhub/features/accounts/domain/models/account_page.dart';
import 'package:finhub/features/accounts/domain/models/account_sort_field.dart';
import 'package:finhub/features/accounts/domain/models/accounts_filter_option.dart';
import 'package:finhub/shared/models/sort_order.dart';

/// [AccountsRepository] backed by `assets/mock-data/accounts/list.json`.
///
/// The filtering, searching and sorting the list endpoint used to do
/// server-side happens here instead, so the list screen's controls behave the
/// same way they always did.
class AccountsMockRepository implements AccountsRepository {
  /// Creates the repository over [_source], scoped to [_scope]'s advisor.
  AccountsMockRepository(this._source, this._scope);

  final MockDataSource _source;
  final DataScope _scope;

  @override
  Future<AccountPage> getAccounts({
    required AccountSortField sortBy,
    required SortOrder sortOrder,
    AccountsFilterOption filter = AccountsFilterOption.all,
    String? cursor,
    String? search,
  }) async {
    final all = await _source.listScoped('accounts/list.json', _scope.advisorId);

    final filtered = switch (filter) {
      AccountsFilterOption.householdLinked => filterRows(all, (row) => row['householdId'] != null),
      AccountsFilterOption.standalone => filterRows(all, (row) => row['householdId'] == null),
      AccountsFilterOption.all => all,
    };
    final searched = searchRows(filtered, search, ['accountName', 'accountNumber']);
    final sorted = sortRows(
      searched,
      sortBy == AccountSortField.name ? 'accountName' : 'currentValueCents',
      ascending: sortOrder == SortOrder.asc,
    );

    // Everything comes back on the first page — there is no cursor to hand
    // back, so the list simply stops paging.
    return AccountPage(
      accounts: sorted.map(Account.fromApiJson).toList(),
      nextCursor: null,
      totalCount: sorted.length,
    );
  }
}
