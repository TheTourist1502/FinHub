import 'package:finhub/features/commissions_detailed_view/domain/models/commission_detail_transaction_card.dart';

/// Abstract data-access contract for fetching commission transactions for a
/// single account.
// ignore: one_member_abstracts
abstract class CommissionsDetailedViewRepository {
  /// Returns all commission transactions for [accountId].
  Future<List<CommissionDetailTransactionCard>> getCommissionDetailsByAccountId(String accountId);
}
