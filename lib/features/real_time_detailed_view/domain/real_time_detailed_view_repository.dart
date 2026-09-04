import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_position.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_transaction.dart';

/// Abstract repository for Real-Time Detailed View data operations.
///
/// Positions and transactions are fetched separately so each tab can load,
/// fail, and retry on its own — a holdings failure must not blank the whole
/// screen.
abstract interface class RealTimeDetailedViewRepository {
  /// Returns live positions for the given [accountId].
  ///
  /// Account display metadata (name, number, type) is not included here —
  /// it comes from the already-fetched account list the user picked from,
  /// via `realTimeAccountsNotifierProvider`.
  Future<List<RealTimePosition>> getPositions(String accountId);

  /// Returns recent transactions for the given [accountId].
  Future<List<RealTimeTransaction>> getTransactions(String accountId);
}
