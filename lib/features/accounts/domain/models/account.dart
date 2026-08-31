import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// Reads a display string the API may send as `null` or omit entirely.
///
/// Returns `''` for anything that is not a [String]. Accounts are parsed as a
/// batch, so an unguarded cast here would drop a whole page over one bad record.
String _str(dynamic v) => v is String ? v : '';

/// Treats an empty string as `null` (API sends `""` instead of omitting the field).
String? _emptyToNull(dynamic v) {
  final s = _str(v);
  return s.isEmpty ? null : s;
}

/// A single asset-class allocation entry returned in the accounts list response.
@immutable
class AccountAssetAllocation {
  /// Creates an [AccountAssetAllocation].
  const AccountAssetAllocation({
    required this.assetClass,
    required this.marketValue,
    required this.allocationPercentage,
  });

  /// Deserialises from the live API response (camelCase keys, string percentage).
  ///
  /// Despite its `*Cents` suffix, `marketValueCents` carries a dollar amount —
  /// it is parsed as-is, with no division by 100.
  ///
  /// Read defensively for the same reason as [Account.fromApiJson] — these
  /// entries are nested inside a batch parse.
  factory AccountAssetAllocation.fromApiJson(Map<String, dynamic> json) => AccountAssetAllocation(
    assetClass: _str(json['assetClass']),
    marketValue: parseNum(json['marketValueCents']),
    allocationPercentage: parseNum(json['allocationPercentage']),
  );

  /// Asset class name (e.g. "Equity", "Fixed Income").
  final String assetClass;

  /// Total market value for this asset class in USD.
  final double marketValue;

  /// Percentage of the account's total value in this asset class.
  final double allocationPercentage;
}

/// A single investment account managed under an advisor's book of business.
@immutable
class Account {
  /// Creates an [Account].
  const Account({
    required this.id,
    required this.accountNumber,
    required this.accountName,
    required this.accountType,
    required this.currentValue,
    required this.cashAvailable,
    required this.riskProfile,
    required this.aumChange,
    required this.aumChangePercentage,
    required this.custodian,
    required this.asOfDate,
    required this.assetAllocation,
    this.householdId,
  });

  /// Builds an [Account] from the API response.
  ///
  /// Every field is read through a null-tolerant helper rather than a direct
  /// cast. The accounts endpoint returns up to 50 records that are parsed in a
  /// single `map`, so one `null` where a value is expected would otherwise
  /// abort the whole page instead of degrading one record — the backend has
  /// already been seen sending `custodian: null`.
  ///
  /// Monetary values already arrive as dollar amounts despite their `*Cents`
  /// key names, so they are parsed as-is with no division by 100.
  /// [aumChangePercentage] may be a string or a number, which [parseNum]
  /// handles. `householdId` only appears on household-scoped responses.
  factory Account.fromApiJson(Map<String, dynamic> json) => Account(
    id: _str(json['id']),
    householdId: _emptyToNull(json['householdId']),
    accountNumber: _str(json['accountNumber']),
    accountName: _str(json['accountName']),
    accountType: _str(json['accountType']),
    currentValue: parseNum(json['currentValueCents']),
    cashAvailable: parseNum(json['cashAvailableCents']),
    riskProfile: _str(json['riskProfile']),
    aumChange: parseNum(json['aumChangeCents']),
    aumChangePercentage: parseNum(json['aumChangePercentage']),
    custodian: _str(json['custodian']),
    asOfDate: parseOptionalDateTime(json['asOfDate']),
    assetAllocation: (json['assetAllocation'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(AccountAssetAllocation.fromApiJson)
        .toList(),
  );

  /// Unique record identifier (UUID).
  final String id;

  /// Parent household ID; `null` when the API response omits it.
  final String? householdId;

  /// Account number (e.g. "ACCP001"), which is also the account's identifier.
  ///
  /// Mask it with `maskAccountNumber` before showing it to the user.
  final String accountNumber;

  /// Full client name.
  final String accountName;

  /// Account type label (e.g. "BROKERAGE", "IRA").
  final String accountType;

  /// Current market value in USD.
  final double currentValue;

  /// Available cash in USD; `0` when the API reports no cash figure.
  final double cashAvailable;

  /// Risk profile label (e.g. "MODERATE", "MODERATE_AGGRESSIVE", "AGGRESSIVE").
  final String riskProfile;

  /// AUM change year-to-date in USD.
  final double aumChange;

  /// AUM change year-to-date as a percentage (e.g. 9.60).
  final double aumChangePercentage;

  /// Custodian name (e.g. "PERSHING").
  final String custodian;

  /// Date the money figures are valued as of; `null` when the API omits it or
  /// sends an unparseable value.
  ///
  /// A calendar date with no time — never time-zone convert it for display.
  final DateTime? asOfDate;

  /// Asset class breakdown for this account.
  ///
  /// Empty when the API response omits `assetAllocation`.
  final List<AccountAssetAllocation> assetAllocation;

  // ---------------------------------------------------------------------------
  // Computed helpers

  /// The account's identifier — the same value as [accountNumber].
  ///
  /// The API sends no top-level `accountId`; it identifies an account by its
  /// number. This alias lets callers filling an `:accountId` route segment or
  /// provider key say what they mean. Never render it — it is unmasked.
  String get accountId => accountNumber;

  /// Whether this account is linked to a household.
  bool get isHouseholdLinked => householdId != null;

  /// Two-letter initials extracted from [accountName].
  String get initials {
    final parts = accountName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    if (parts.first.isNotEmpty) return parts.first[0].toUpperCase();
    return '?';
  }
}
