import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';

/// Contract for fetching all dashboard data sections.
///
/// `DashboardApi` implements this interface, backed by the live FinHub REST API.
abstract class DashboardRepository {
  /// Returns the authoritative dashboard summary (total AUM + total commission).
  ///
  /// Calls `GET /v1/dashboard/summary`. The FA identity is resolved server-side
  /// from the Bearer token.
  Future<DashboardSummary> getDashboardSummary();

  /// Returns the FA's weekly AUM history, sorted chronologically.
  Future<List<FaAumEntry>> getFaAumHistory();

  /// Returns the FA's weekly commission history from the live API, sorted chronologically.
  ///
  /// Calls `GET /v1/commissions/history`.
  Future<List<FaCommissionEntry>> getCommissionHistory();

  /// Returns all commission summary entries for the authenticated FA.
  ///
  /// Calls `GET /v1/commissions/summary`. Callers aggregate [CommissionSummaryEntry.commissionEarned]
  /// to produce the total displayed on the dashboard.
  Future<List<CommissionSummaryEntry>> getCommissionSummary();

  /// Returns asset allocation breakdown for the FA's entire book of business.
  Future<List<AssetAllocation>> getFaAssetAllocations();

  /// Returns household AUM insights for the authenticated FA.
  ///
  /// Calls `GET /v1/dashboard/household-insights`.
  Future<List<HouseholdInsight>> getHouseholds();

  /// Returns recent transactions across all FA accounts, sorted descending by date.
  Future<List<RecentTransaction>> getRecentTransactions();

  /// Returns the ordered list of quick-action shortcuts for the dashboard.
  Future<List<QuickAction>> getDashboardQuickActions();
}
