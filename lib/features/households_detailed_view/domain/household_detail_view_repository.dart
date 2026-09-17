import 'package:finhub/features/accounts/domain/models/account.dart';
import 'package:finhub/features/households_detailed_view/domain/models/household_detail_view.dart';

/// Abstract repository for fetching the detailed view of a single household.
abstract interface class HouseholdDetailViewRepository {
  /// Fetches full detail for the household identified by [householdId],
  /// including asset allocation, member accounts, and recent transactions.
  Future<HouseholdDetailView> getHouseholdDetail(String householdId);

  /// Fetches only [householdId]'s member accounts and transactions.
  ///
  /// Used when the detail screen already has identity and asset-allocation
  /// data from the household passed in from the households list, so it never
  /// reads the household/allocation fixtures a second time.
  Future<(List<Account>, List<HouseholdDetailTransaction>)> getHouseholdAccountsAndTransactions(String householdId);
}
