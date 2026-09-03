import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// Asset allocation breakdown for a specific household.
@immutable
class HouseholdAssetAllocation {
  /// Creates a [HouseholdAssetAllocation] with all required fields.
  const HouseholdAssetAllocation({
    required this.id,
    required this.householdId,
    required this.assetClass,
    required this.marketValue,
    required this.allocationPercentage,
    required this.asOfDate,
  });

  /// Creates a [HouseholdAssetAllocation] from the live API response.
  ///
  /// Despite its name, `marketValueCents` carries a dollar amount — it is
  /// parsed as-is, with no division by 100.
  /// `allocationPercentage` arrives as a numeric string (e.g. `"40.00"`)
  /// and is parsed to a [double].
  factory HouseholdAssetAllocation.fromApiJson(Map<String, dynamic> json) => HouseholdAssetAllocation(
    id: json['id'] as String,
    householdId: json['householdId'] as String,
    assetClass: json['assetClass'] as String,
    marketValue: parseNum(json['marketValueCents']),
    allocationPercentage: parseNum(json['allocationPercentage']),
    asOfDate: parseOptionalDateTime(json['asOfDate']),
  );

  /// Unique record identifier (UUID).
  final String id;

  /// Household this allocation belongs to.
  final String householdId;

  /// Asset class label (e.g. "Equity", "Fixed Income").
  final String assetClass;

  /// Market value for this class in USD.
  final double marketValue;

  /// Percentage share of total household AUM (0–100).
  final double allocationPercentage;

  /// Calendar date this snapshot was taken. Date-only — never time-zone
  /// shifted. Null when the backend sent no (or an unparseable) date.
  final DateTime? asOfDate;
}

/// A detailed client household managed by a financial advisor.
@immutable
class HouseholdDetail {
  /// Creates a [HouseholdDetail] with all required fields.
  const HouseholdDetail({
    required this.id,
    required this.householdId,
    required this.householdName,
    required this.totalAum,
    required this.aumChange,
    required this.aumChangePercentage,
    required this.asOfDate,
    required this.assetAllocation,
    required this.totalAccounts,
  });

  /// Parses a [HouseholdDetail] from the live API response.
  ///
  /// Despite the `Cents` suffix, `totalAumCents` and `aumChangeCents` carry
  /// dollar amounts — they are parsed as-is, with no division by 100.
  /// `aumChangePercentage` arrives as a numeric string (e.g. `"3.80"`) and is
  /// parsed to a [double]. `assetAllocation` is embedded in the response.
  factory HouseholdDetail.fromApiJson(Map<String, dynamic> json) {
    final rawAllocations = (json['assetAllocation'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    return HouseholdDetail(
      id: json['id'] as String,
      householdId: json['householdId'] as String,
      householdName: json['householdName'] as String,
      totalAum: parseNum(json['totalAumCents']),
      aumChange: parseNum(json['aumChangeCents']),
      aumChangePercentage: parseNum(json['aumChangePercentage']),
      asOfDate: parseOptionalDateTime(json['asOfDate']),
      assetAllocation: rawAllocations.map(HouseholdAssetAllocation.fromApiJson).toList(),
      totalAccounts: parseInt(json['totalAccounts']),
    );
  }

  /// Unique record identifier (UUID).
  final String id;

  /// Human-readable household identifier (e.g. "HHP001").
  final String householdId;

  /// Display name of the household.
  final String householdName;

  /// Total assets under management in USD.
  final double totalAum;

  /// Absolute AUM change in USD.
  final double aumChange;

  /// AUM change year-to-date as a percentage (e.g. 9.60).
  final double aumChangePercentage;

  /// Calendar date this snapshot was taken. Date-only — never time-zone
  /// shifted. Null when the backend sent no (or an unparseable) date.
  final DateTime? asOfDate;

  /// Asset class breakdown for this household.
  final List<HouseholdAssetAllocation> assetAllocation;

  /// Total number of accounts in this household. Defaults to 0 when the API
  /// omits the field.
  final int totalAccounts;
}
