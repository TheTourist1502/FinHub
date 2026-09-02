import 'package:finhub/core/utils/json_parsing.dart';
import 'package:finhub/features/account_detail_view/domain/models/account_position.dart';
import 'package:finhub/features/account_detail_view/domain/models/account_transaction.dart';
import 'package:flutter/foundation.dart';

/// Detailed view of a single investment account including positions,
/// transactions, and asset allocation — returned by [AccountDetailRepository.getDetailedAccount].
@immutable
class DetailedAccount {
  /// Creates a [DetailedAccount].
  const DetailedAccount({
    required this.accountId,
    required this.accountNumber,
    required this.accountName,
    required this.accountType,
    required this.currentValue,
    required this.cashAvailable,
    required this.riskProfile,
    required this.custodian,
    required this.assetAllocation,
    required this.positions,
    required this.transactions,
    this.householdId,
  });

  /// Assembles a [DetailedAccount] from the live API responses.
  ///
  /// - [accountJson]     — response body from `GET /v1/accounts/{id}`.
  /// - [allocationList]  — array from `GET /v1/accounts/{id}/asset-allocation`.
  /// - [positionList]    — `data` array from `GET /v1/accounts/{id}/positions`.
  /// - [transactionList] — `data` array from `GET /v1/accounts/{id}/transactions`.
  ///
  /// Monetary values already arrive as dollar amounts despite their `*Cents`
  /// key names, so they are parsed as-is with no division by 100;
  /// `cashAvailableCents` may arrive as `null`, which [parseNum] falls back to
  /// `0`. The account payload embeds its own `assetAllocation` array;
  /// when present it takes precedence over [allocationList]. The financial
  /// advisor identifier is not part of the payload (it is inferred
  /// server-side from the Bearer token), and `householdId` is only present
  /// on household-scoped responses.
  factory DetailedAccount.fromApiJson({
    required Map<String, dynamic> accountJson,
    required List<Map<String, dynamic>> allocationList,
    required List<Map<String, dynamic>> positionList,
    required List<Map<String, dynamic>> transactionList,
  }) {
    final embeddedAllocations =
        (accountJson['assetAllocation'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? allocationList;
    return DetailedAccount(
      // The single-account payload identifies itself with `accountNumber`; the
      // nested/list payloads use `accountId`. Fall back through both before the
      // surrogate UUID `id`, since only the first two are route-resolvable.
      accountId: (accountJson['accountId'] ?? accountJson['accountNumber'] ?? accountJson['id']) as String,
      householdId: accountJson['householdId'] as String?,
      accountNumber: accountJson['accountNumber'] as String,
      accountName: accountJson['accountName'] as String,
      accountType: accountJson['accountType'] as String,
      currentValue: parseNum(accountJson['currentValueCents']),
      cashAvailable: parseNum(accountJson['cashAvailableCents']),
      riskProfile: accountJson['riskProfile'] as String,
      custodian: accountJson['custodian'] as String? ?? '',
      assetAllocation: embeddedAllocations.map(AccountAllocationEntry.fromApiJson).toList(),
      positions: positionList.map(AccountPosition.fromApiJson).toList(),
      transactions: transactionList.map(AccountTransaction.fromApiJson).toList(),
    );
  }

  /// Human-readable account identifier (e.g. "ACC-AH-007-1").
  final String accountId;

  /// Parent household ID; `null` when the API response omits it.
  final String? householdId;

  /// Displayable account number (e.g. "XXXX3025").
  final String accountNumber;

  /// Full account name (e.g. "Hernandez Family Brokerage").
  final String accountName;

  /// Account type label (e.g. "BROKERAGE").
  final String accountType;

  /// Current total market value in USD.
  final double currentValue;

  /// Available cash in USD; `0` when the API reports no cash figure.
  final double cashAvailable;

  /// Risk profile label (e.g. "MODERATE").
  final String riskProfile;

  /// Custodian name (e.g. "PERSHING").
  final String custodian;

  /// Asset class breakdown for this account.
  final List<AccountAllocationEntry> assetAllocation;

  /// Individual security positions.
  final List<AccountPosition> positions;

  /// Recent transactions.
  final List<AccountTransaction> transactions;

  /// Two-letter initials from [accountName].
  String get initials {
    final parts = accountName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    if (parts.first.isNotEmpty) return parts.first[0].toUpperCase();
    return '?';
  }
}

/// Asset class allocation entry within a [DetailedAccount].
@immutable
class AccountAllocationEntry {
  /// Creates an [AccountAllocationEntry].
  const AccountAllocationEntry({
    required this.assetClass,
    required this.marketValue,
    required this.allocationPercentage,
  });

  /// Deserialises from the live API response (camelCase keys, string percentage).
  ///
  /// Despite its `*Cents` suffix, `marketValueCents` carries a dollar amount —
  /// it is parsed as-is, with no division by 100.
  factory AccountAllocationEntry.fromApiJson(Map<String, dynamic> json) => AccountAllocationEntry(
    assetClass: json['assetClass'] as String,
    marketValue: parseNum(json['marketValueCents']),
    allocationPercentage: parseNum(json['allocationPercentage']),
  );

  /// Asset class name (e.g. "EQUITY", "FIXED_INCOME").
  final String assetClass;

  /// Total market value for this asset class in USD.
  final double marketValue;

  /// Percentage of the account's total value in this asset class.
  final double allocationPercentage;
}
