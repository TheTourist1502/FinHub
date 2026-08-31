import 'package:finhub/features/accounts/domain/models/account_page.dart';
import 'package:finhub/features/accounts/domain/models/account_sort_field.dart';
import 'package:finhub/features/accounts/domain/models/accounts_filter_option.dart';
import 'package:finhub/shared/models/sort_order.dart';

/// Abstract repository for fetching the account list.
// ignore: one_member_abstracts
abstract class AccountsRepository {
  /// Fetches one page of accounts visible to the current advisor.
  ///
  /// [cursor] comes from the previous [AccountPage.nextCursor]; omit it for
  /// the first page. [search] filters by account name or number; omit it for
  /// the full list. [filter] narrows by account type, and
  /// [AccountsFilterOption.all] sends nothing. [sortBy] and [sortOrder] are
  /// sent on every request, including the first, so the server's order always
  /// matches what the UI shows.
  Future<AccountPage> getAccounts({
    required AccountSortField sortBy,
    required SortOrder sortOrder,
    AccountsFilterOption filter = AccountsFilterOption.all,
    String? cursor,
    String? search,
  });
}
