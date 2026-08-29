import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// Represents a single weekly AUM data point for a financial advisor.
@immutable
class FaAumEntry {
  /// Creates an [FaAumEntry] with all required fields.
  const FaAumEntry({
    required this.weekDate,
    required this.aum,
  });

  /// Creates a [FaAumEntry] from the `/v1/dashboard/aum-history` API response.
  ///
  /// Despite its name, `aumCents` already carries a dollar amount — it is read
  /// as-is with no division by 100.
  factory FaAumEntry.fromApiJson(Map<String, dynamic> json) => FaAumEntry(
    weekDate: parseOptionalDateTime(json['weekDate']),
    aum: parseNum(json['aumCents']),
  );

  /// The week-end date for this data point, or `null` when the backend sent
  /// no date. A pure calendar date — never convert it to local time.
  final DateTime? weekDate;

  /// Total assets under management in USD.
  final double aum;
}

/// Represents a single weekly commission data point for a financial advisor.
@immutable
class FaCommissionEntry {
  /// Creates a [FaCommissionEntry] with all required fields.
  const FaCommissionEntry({
    required this.weekDate,
    required this.commission,
  });

  /// Creates a [FaCommissionEntry] from the `/v1/commissions/history` API response.
  ///
  /// Despite its name, `commissionCents` already carries a dollar amount — it
  /// is read as-is with no division by 100.
  factory FaCommissionEntry.fromApiJson(Map<String, dynamic> json) => FaCommissionEntry(
    weekDate: parseOptionalDateTime(json['weekDate']),
    commission: parseNum(json['commissionCents']),
  );

  /// The week-end date for this data point, or `null` when the backend sent
  /// no date. A pure calendar date — never convert it to local time.
  final DateTime? weekDate;

  /// Commission earned for this week in USD.
  final double commission;
}

// ---------------------------------------------------------------------------
// Dashboard summary
// ---------------------------------------------------------------------------

/// Authoritative dashboard summary from `/v1/dashboard/summary`.
///
/// Provides the FA's current total AUM and total commission as of [asOfDate],
/// derived server-side rather than from aggregated history entries.
@immutable
class DashboardSummary {
  /// Creates a [DashboardSummary] with all required fields.
  const DashboardSummary({
    required this.id,
    required this.totalAum,
    required this.totalCommission,
    required this.asOfDate,
  });

  /// Creates a [DashboardSummary] from the `/v1/dashboard/summary` API response.
  ///
  /// Despite the `Cents` suffix, `totalAumCents` and `totalCommissionCents`
  /// already carry dollar amounts — they are read as-is with no division.
  factory DashboardSummary.fromApiJson(Map<String, dynamic> json) => DashboardSummary(
    id: json['id'] as String,
    totalAum: parseNum(json['totalAumCents']),
    totalCommission: parseNum(json['totalCommissionCents']),
    asOfDate: parseOptionalDateTime(json['asOfDate']),
  );

  /// Unique record identifier.
  final String id;

  /// Total assets under management in USD.
  final double totalAum;

  /// Total commissions earned in USD.
  final double totalCommission;

  /// The date this snapshot was calculated, or `null` when the backend sent
  /// no date. A pure calendar date — never convert it to local time.
  final DateTime? asOfDate;
}

// ---------------------------------------------------------------------------
// Commission summary
// ---------------------------------------------------------------------------

/// A single commission summary entry from `/v1/commissions/summary`.
///
/// Represents one commission-source record. The provider aggregates a list of
/// these to produce the total displayed on the dashboard.
@immutable
class CommissionSummaryEntry {
  /// Creates a [CommissionSummaryEntry] with all required fields.
  const CommissionSummaryEntry({
    required this.id,
    required this.sourceId,
    required this.transactionAmount,
    required this.commissionEarned,
    required this.asOfDate,
  });

  /// Creates a [CommissionSummaryEntry] from the `/v1/commissions/summary` API response.
  ///
  /// Despite the `Cents` suffix, `transactionAmountCents` and
  /// `commissionEarnedCents` already carry dollar amounts — they are read
  /// as-is with no division.
  factory CommissionSummaryEntry.fromApiJson(Map<String, dynamic> json) => CommissionSummaryEntry(
    id: json['id'] as String,
    sourceId: json['sourceId'] as String,
    transactionAmount: parseNum(json['transactionAmountCents']),
    commissionEarned: parseNum(json['commissionEarnedCents']),
    asOfDate: parseOptionalDateTime(json['asOfDate']),
  );

  /// Unique record identifier.
  final String id;

  /// Originating source identifier.
  final String sourceId;

  /// Total transaction volume for this record in USD.
  final double transactionAmount;

  /// Commission earned on the transaction volume in USD.
  final double commissionEarned;

  /// The date this record was calculated, or `null` when the backend sent no
  /// date. A pure calendar date — never convert it to local time.
  final DateTime? asOfDate;
}

/// Asset allocation breakdown for a financial advisor's book of business.
@immutable
class AssetAllocation {
  /// Creates an [AssetAllocation] with all required fields.
  const AssetAllocation({
    required this.assetClass,
    required this.marketValue,
    required this.allocationPercentage,
    required this.asOfDate,
  });

  /// Creates an [AssetAllocation] from the `/v1/dashboard/asset-allocation` API response.
  ///
  /// Despite its name, `marketValueCents` already carries a dollar amount — it
  /// is read as-is with no division by 100.
  /// [allocationPercentage] arrives as a numeric string (e.g. `"45.50"`) and
  /// is parsed to a [double].
  factory AssetAllocation.fromApiJson(Map<String, dynamic> json) => AssetAllocation(
    assetClass: json['assetClass'] as String,
    marketValue: parseNum(json['marketValueCents']),
    allocationPercentage: parseNum(json['allocationPercentage']),
    asOfDate: parseOptionalDateTime(json['asOfDate']),
  );

  /// Human-readable asset class label (e.g. "Equity", "Fixed Income").
  final String assetClass;

  /// Total market value for this class in USD.
  final double marketValue;

  /// Percentage share of total AUM (0–100).
  final double allocationPercentage;

  /// The date this snapshot was taken, or `null` when the backend sent no
  /// date. A pure calendar date — never convert it to local time.
  final DateTime? asOfDate;
}

/// A household AUM insight from `/v1/dashboard/household-insights`.
///
/// Carries the household's total AUM alongside its absolute AUM change
/// (`aumChangeCents`), as of the [asOfDate] snapshot date.
@immutable
class HouseholdInsight {
  /// Creates a [HouseholdInsight] with all required fields.
  const HouseholdInsight({
    required this.id,
    required this.householdId,
    required this.householdName,
    required this.totalAum,
    required this.aumChange,
    required this.aumChangePercentage,
    required this.asOfDate,
  });

  /// Creates a [HouseholdInsight] from the `/v1/dashboard/household-insights`
  /// API response shape.
  ///
  /// Despite the `Cents` suffix, `totalAumCents` and `aumChangeCents` already
  /// carry dollar amounts — they are read as-is. [aumChangePercentage]
  /// arrives as a numeric string (e.g. `"18.48"`) and is parsed to a [double].
  /// [asOfDate] is a pure calendar date — it is never converted to local
  /// time, so no time-zone shift can move it to a different day.
  factory HouseholdInsight.fromApiJson(Map<String, dynamic> json) => HouseholdInsight(
    id: json['id'] as String,
    householdId: json['householdId'] as String,
    householdName: json['householdName'] as String,
    totalAum: parseNum(json['totalAumCents']),
    aumChange: parseNum(json['aumChangeCents']),
    aumChangePercentage: parseNum(json['aumChangePercentage']),
    asOfDate: parseOptionalDateTime(json['asOfDate']),
  );

  /// Unique record identifier (UUID).
  final String id;

  /// Human-readable household identifier (e.g. "HHP001").
  final String householdId;

  /// Display name of the household.
  final String householdName;

  /// Total assets under management for this household in USD.
  final double totalAum;

  /// Absolute AUM change in USD.
  final double aumChange;

  /// AUM change as a percentage (e.g. 18.48).
  final double aumChangePercentage;

  /// The date this snapshot was calculated, or `null` when the backend sent
  /// no date. A pure calendar date — never convert it to local time.
  final DateTime? asOfDate;
}

/// A recent account transaction enriched with account context.
@immutable
class RecentTransaction {
  /// Creates a [RecentTransaction] with all required fields.
  const RecentTransaction({
    required this.transactionId,
    required this.accountId,
    required this.transactionType,
    required this.amount,
    required this.quantity,
    required this.unitPrice,
    this.accountName = '',
    this.accountType,
    this.securityName,
    this.tickerSymbol,
    this.assetClass,
    this.transactionDescription,
    this.sourceId,
    this.transactionDate,
    this.asOfDate,
  });

  /// Creates a [RecentTransaction] from the `/v1/dashboard/recent-transactions` API response.
  ///
  /// The record identifier arrives as `id`. [quantity] arrives as a numeric
  /// string (e.g. `"3.0000"`) or number and keeps its fractional part.
  /// Despite the `Cents` suffix, `unitPriceCents` and `amountCents` already
  /// carry dollar amounts — they are read as-is with no division by 100.
  factory RecentTransaction.fromApiJson(Map<String, dynamic> json) => RecentTransaction(
    transactionId: parseString(json['id']),
    sourceId: parseOptionalString(json['sourceId']),
    accountId: parseString(json['accountId']),
    transactionType: parseString(json['transactionType']),
    securityName: parseOptionalString(json['securityName']),
    tickerSymbol: parseOptionalString(json['tickerSymbol']),
    assetClass: parseOptionalString(json['assetClass']),
    transactionDescription: parseOptionalString(json['transactionDescription']),
    quantity: parseNum(json['quantity']),
    unitPrice: parseNum(json['unitPriceCents']),
    amount: parseNum(json['amountCents']),
    transactionDate: parseOptionalDateTime(json['tradeDate']),
    asOfDate: parseOptionalDateTime(json['asOfDate']),
    accountName: parseString(json['accountName']),
    accountType: parseOptionalString(json['accountType']),
  );

  /// Unique transaction identifier (the API's `id`).
  final String transactionId;

  /// Upstream custodian identifier for this record. Null when not provided.
  final String? sourceId;

  /// Account that executed this transaction.
  final String accountId;

  /// Transaction type: BUY, SELL, DIVIDEND, or FEE. Empty when the backend
  /// sends no type.
  final String transactionType;

  /// Name of the traded security (null for FEE/corporate-action types).
  final String? securityName;

  /// Ticker symbol (null for FEE/corporate-action types).
  final String? tickerSymbol;

  /// Asset class of the traded security (e.g. "ETF"). Null when not provided.
  final String? assetClass;

  /// Number of units traded. `0` when the transaction has no unit quantity.
  final double quantity;

  /// Price per unit at execution. `0` when not applicable (DIVIDEND/FEE).
  final double unitPrice;

  /// Raw amount from the source. For display, prefer [displayAmount].
  final double amount;

  /// Execution date of the transaction (from `tradeDate`), or `null` when the
  /// backend sent no date.
  ///
  /// A pure trade date — never convert it to local time.
  final DateTime? transactionDate;

  /// Free-text description of the transaction. Null when not provided.
  final String? transactionDescription;

  /// Position date this record was reported against; `null` when absent.
  ///
  /// A pure calendar date — never convert it to local time.
  final DateTime? asOfDate;

  /// Display name of the account (e.g. "Wright IRA").
  final String accountName;

  /// Account type (e.g. "IRA", "Brokerage").
  final String? accountType;

  /// The monetary amount to display: the raw signed [amount] from the source.
  ///
  /// The sign is kept, so an outflow renders with a leading minus in addition
  /// to the direction its type badge conveys.
  double get displayAmount => amount;
}

/// A quick-action shortcut shown on the dashboard.
///
/// The [icon] field holds an MDI icon key (e.g. `"account_search"`) that the
/// widget resolves to a concrete SVG string via a compile-time lookup map.
@immutable
class QuickAction {
  /// Creates a [QuickAction] with all required fields.
  const QuickAction({
    required this.id,
    required this.label,
    required this.icon,
  });

  /// Unique identifier for this action (e.g. `"client_search"`).
  final String id;

  /// Human-readable label as returned by the API.
  final String label;

  /// MDI icon key string (e.g. `"account_search"`).
  final String icon;
}
