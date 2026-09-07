import 'package:finhub/features/my_commissions/domain/models/commission_data.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_summary.dart';

/// Abstract contract for loading commission data for the authenticated advisor.
///
/// The concrete implementation ([MyCommissionsApi]) calls the live commission
/// summary and top-accounts endpoints.
abstract class MyCommissionsRepository {
  /// Returns the commission summary (stats, top accounts, trend) for the
  /// current financial advisor. Does not include transaction-level records —
  /// use [getCommissionSummary] for those.
  Future<CommissionData> getMyCommissionsData();

  /// Fetches one page of commission transactions from `GET /v1/commissions/summary`.
  ///
  /// Pass [cursor] from the previous [CommissionTransactionPage.nextCursor] to
  /// load the next page; omit it (or pass `null`) for the first page.
  ///
  /// Each entry in the response already carries its own account identity
  /// fields (`accountName` / `accountNumber`), so no client-side enrichment
  /// is needed.
  Future<CommissionTransactionPage> getCommissionSummary({String? cursor});
}
