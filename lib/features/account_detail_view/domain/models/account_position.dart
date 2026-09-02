import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// A single security position held within an account.
@immutable
class AccountPosition {
  /// Creates an [AccountPosition].
  const AccountPosition({
    required this.id,
    required this.accountId,
    required this.securityName,
    required this.securityType,
    required this.quantity,
    required this.currentPrice,
    required this.marketValue,
    required this.allocationPercentage,
    required this.asOfDate,
    this.tickerSymbol,
  });

  /// Deserialises from a raw JSON map (snake_case keys).
  factory AccountPosition.fromJson(Map<String, dynamic> json) => AccountPosition(
    id: json['id'] as String,
    accountId: json['account_id'] as String,
    securityName: json['security_name'] as String,
    tickerSymbol: json['ticker_symbol'] as String?,
    securityType: json['security_type'] as String,
    quantity: parseNum(json['quantity']),
    currentPrice: parseNum(json['current_price']),
    marketValue: parseNum(json['market_value']),
    allocationPercentage: parseNum(json['allocation_percentage']),
    asOfDate: parseOptionalDateTime(json['as_of_date']),
  );

  /// Deserialises from the live API response (camelCase keys, string quantity/percentage).
  ///
  /// Despite their `*Cents` suffix, `currentPriceCents` and `marketValueCents`
  /// carry dollar amounts — they are parsed as-is, with no division by 100.
  ///
  /// `tickerSymbol` is `null` for cash/sweep positions with no underlying security.
  factory AccountPosition.fromApiJson(Map<String, dynamic> json) => AccountPosition(
    id: parseString(json['id']),
    accountId: parseString(json['accountId']),
    securityName: parseString(json['securityName']),
    tickerSymbol: parseOptionalString(json['tickerSymbol']),
    securityType: parseString(json['securityType']),
    quantity: parseNum(json['quantity']),
    currentPrice: parseNum(json['currentPriceCents']),
    marketValue: parseNum(json['marketValueCents']),
    allocationPercentage: parseNum(json['allocationPercentage']),
    asOfDate: parseOptionalDateTime(json['asOfDate']),
  );

  /// Unique position identifier (UUID from the API).
  final String id;

  /// Account this position belongs to.
  final String accountId;

  /// Full name of the security (e.g. "Apple Inc.").
  final String securityName;

  /// Exchange ticker symbol (e.g. "AAPL"). Null for cash/sweep positions
  /// with no underlying security.
  final String? tickerSymbol;

  /// Security type (e.g. "EQUITY", "ETF").
  final String securityType;

  /// Number of units held.
  final double quantity;

  /// Current market price per unit in USD.
  final double currentPrice;

  /// Total current market value in USD.
  final double marketValue;

  /// Percentage of the total account value this position represents.
  final double allocationPercentage;

  /// Data snapshot date, or `null` when the backend sent no date.
  ///
  /// A pure calendar date — never convert it to local time.
  final DateTime? asOfDate;
}
