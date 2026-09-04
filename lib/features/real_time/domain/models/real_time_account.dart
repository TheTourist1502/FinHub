import 'package:flutter/foundation.dart';

/// A financial account available for real-time data lookup.
@immutable
class RealTimeAccount {
  /// Creates a [RealTimeAccount].
  const RealTimeAccount({
    required this.accountId,
    required this.accountNumber,
    required this.accountName,
    this.accountType = '',
  });

  /// Deserialises from an `assets/mock-data/accounts/list.json` row.
  ///
  /// That fixture always carries `accountId`, `accountNumber`, `accountName`
  /// and `accountType`, so [accountId] never falls back to [accountNumber]
  /// here — the fallback is kept only for robustness against a row that omits it.
  factory RealTimeAccount.fromApiJson(Map<String, dynamic> json) {
    final accountNumber = json['accountNumber'] as String;
    return RealTimeAccount(
      accountId: json['accountId'] as String? ?? accountNumber,
      accountNumber: accountNumber,
      accountName: json['accountName'] as String,
      accountType: json['accountType'] as String? ?? '',
    );
  }

  /// Unique account identifier (e.g. "ACCP001").
  final String accountId;

  /// Human-readable account number shown to the advisor (e.g. "BRK8X4M9217").
  final String accountNumber;

  /// Full display name of the account holder.
  final String accountName;

  /// Account type label (e.g. "Investment"), or `''` when the source record
  /// does not supply one.
  final String accountType;
}
