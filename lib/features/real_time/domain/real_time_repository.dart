import 'package:finhub/features/real_time/domain/models/real_time_account_page.dart';

/// Abstract repository for fetching the accounts selectable on the
/// Real-Time tab.
// ignore: one_member_abstracts
abstract interface class RealTimeRepository {
  /// Fetches one page of accounts available for real-time lookup.
  ///
  /// Pass [cursor] from the previous [RealTimeAccountPage.nextCursor] to
  /// load the next page; omit it (or pass `null`) for the first page. Pass
  /// [search] to filter by account number or account name; changing [search]
  /// should be paired with a `null` [cursor] to restart pagination from the
  /// first page of the new result set.
  Future<RealTimeAccountPage> getAccounts({String? cursor, String? search});
}
