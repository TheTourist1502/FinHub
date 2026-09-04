import 'package:flutter/foundation.dart';

/// Account summary shown in the Real-Time Detailed View header card.
///
/// Positions and transactions are not bundled here — each tab loads its own
/// list through its own provider.
@immutable
class RealTimeDetailedData {
  /// Creates a [RealTimeDetailedData].
  const RealTimeDetailedData({
    required this.accountId,
    required this.accountName,
    required this.accountNumber,
    required this.accountType,
  });

  /// Unique internal account identifier (e.g. "ACCP001").
  final String accountId;

  /// Full display name of the account holder.
  final String accountName;

  /// Human-readable account number (e.g. "BRK8X4M9217").
  final String accountNumber;

  /// Account type label (e.g. "Investment").
  final String accountType;
}
