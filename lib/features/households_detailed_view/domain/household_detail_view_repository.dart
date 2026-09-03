import 'package:finhub/features/households_detailed_view/domain/models/household_detail_view.dart';

/// Abstract repository for fetching the detailed view of a single household.
// ignore: one_member_abstracts
abstract interface class HouseholdDetailViewRepository {
  /// Fetches full detail for the household identified by [householdId],
  /// including asset allocation, member accounts, and recent transactions.
  Future<HouseholdDetailView> getHouseholdDetail(String householdId);
}
