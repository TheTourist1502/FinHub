import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// A single intraday account activity entry, sourced from
/// `assets/mock-data/real_time/activities.json`.
@immutable
class RealTimeTransaction {
  /// Creates a [RealTimeTransaction].
  const RealTimeTransaction({
    required this.accountActivity,
    required this.accountActivityDescription,
    required this.cusipIdentifier,
    required this.activityQuantity,
    required this.tradePriceInBaseCurrency,
    this.processDate,
    this.asOfDate,
    this.accountRegistrationTypeCode,
    this.tickerSymbol,
  });

  /// Deserialises a single `activities[]` entry from the fixture.
  ///
  /// [json] must already have the record's top-level `asOfDate` merged in,
  /// since that snapshot timestamp is only stored once, alongside the
  /// `activities` array, not per entry. Despite its `Cents` suffix,
  /// `tradePriceInBaseCurrencyCents` already carries a dollar amount, so it is
  /// parsed as-is with no divide-by-100 conversion.
  factory RealTimeTransaction.fromApiJson(Map<String, dynamic> json) => RealTimeTransaction(
    processDate: parseOptionalDateTime(json['processDate']),
    asOfDate: parseOptionalDateTime(json['asOfDate']),
    accountActivity: json['accountActivity'] as String,
    accountActivityDescription: json['accountActivityDescription'] as String,
    cusipIdentifier: json['cusipIdentifier'] as String,
    activityQuantity: parseNum(json['activityQuantity']),
    tradePriceInBaseCurrency: parseNum(json['tradePriceInBaseCurrencyCents']),
    accountRegistrationTypeCode: json['accountRegistrationTypeCode'] as String?,
    tickerSymbol: json['tickerSymbol'] as String?,
  );

  /// Date the activity was processed; `null` when the fixture omits it or
  /// sends an unparseable value.
  ///
  /// A pure calendar date — never time-zone convert it for display.
  final DateTime? processDate;

  /// Snapshot timestamp for the whole batch, from the fixture's top-level
  /// `asOfDate` field, merged into every activity entry; `null` when absent
  /// or unparseable.
  ///
  /// Has a meaningful time-of-day — format it with `DateFormat.formatLocal()`.
  final DateTime? asOfDate;

  /// Short activity type label (e.g. "MARK TO MARKET").
  final String accountActivity;

  /// Full description of the activity (e.g. "Sale - Apple Inc.").
  final String accountActivityDescription;

  /// CUSIP identifier for the related security (e.g. "USD999997" for cash).
  final String cusipIdentifier;

  /// Quantity of units involved in the activity.
  final double activityQuantity;

  /// Trade price per unit in the account's base currency.
  final double tradePriceInBaseCurrency;

  /// Account registration type code, when applicable.
  final String? accountRegistrationTypeCode;

  /// Exchange ticker symbol. Null for cash activities.
  final String? tickerSymbol;
}
