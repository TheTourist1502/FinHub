import 'package:finhub/features/account_detail_view/domain/models/account_aum_trend.dart';
import 'package:finhub/features/account_detail_view/domain/models/account_position.dart';
import 'package:finhub/features/account_detail_view/domain/models/account_transaction.dart';
import 'package:finhub/features/account_detail_view/domain/models/detailed_account.dart';

/// Abstract repository for fetching the detailed view of a single account.
abstract interface class AccountDetailRepository {
  /// Fetches a single account's full detail by [accountId], including
  /// positions, transactions, and asset allocation.
  Future<DetailedAccount> getDetailedAccount(String accountId);

  /// Fetches only [accountId]'s positions and transactions.
  ///
  /// Used when the detail screen already has identity and asset-allocation
  /// data from the account passed in from a list screen, so it never reads
  /// the account/allocation fixtures a second time.
  Future<(List<AccountPosition>, List<AccountTransaction>)> getAccountPositionsAndTransactions(String accountId);

  /// Fetches weekly AUM trend history for [accountId], sorted chronologically.
  Future<List<AccountAumTrend>> getAccountsAumTrends(String accountId);
}
