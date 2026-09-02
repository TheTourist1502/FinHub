import 'package:finhub/features/account_detail_view/domain/models/account_aum_trend.dart';
import 'package:finhub/features/account_detail_view/domain/models/detailed_account.dart';

/// Abstract repository for fetching the detailed view of a single account.
abstract interface class AccountDetailRepository {
  /// Fetches a single account's full detail by [accountId], including
  /// positions, transactions, and asset allocation.
  Future<DetailedAccount> getDetailedAccount(String accountId);

  /// Fetches weekly AUM trend history for [accountId], sorted chronologically.
  Future<List<AccountAumTrend>> getAccountsAumTrends(String accountId);
}
