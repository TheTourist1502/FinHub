import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// A single intraday security holding, sourced from
/// `assets/mock-data/real_time/holdings.json`.
@immutable
class RealTimePosition {
  /// Creates a [RealTimePosition].
  const RealTimePosition({
    required this.closingPrice,
    required this.dailyChangeAmount,
    required this.dailyChangePercent,
    required this.marketPrice,
    required this.marketValueChange,
    required this.marketValueChangePercent,
    required this.percentageOfPortfolio,
    required this.priceChangeAmount,
    required this.priceChangePercent,
    required this.cusipIdentifier,
    required this.securityDescription,
    this.asOfDate,
    this.tickerSymbol,
    this.underlyingCusipIdentifier,
    this.underlyingTickerSymbol,
  });

  /// Deserialises a single `holdings[]` entry from the fixture.
  ///
  /// Despite the `Cents` suffix, the monetary keys (`closingPriceCents`,
  /// `dailyChangeAmountCents`, `marketPriceCents`, `marketValueChangeCents`,
  /// `priceChangeAmountCents`) already carry dollar amounts, so they are
  /// parsed as-is with no divide-by-100 conversion.
  factory RealTimePosition.fromApiJson(Map<String, dynamic> json) => RealTimePosition(
    asOfDate: parseOptionalDateTime(json['asOfDate']),
    closingPrice: parseNum(json['closingPriceCents']),
    dailyChangeAmount: parseNum(json['dailyChangeAmountCents']),
    dailyChangePercent: parseNum(json['dailyChangePercent']),
    marketPrice: parseNum(json['marketPriceCents']),
    marketValueChange: parseNum(json['marketValueChangeCents']),
    marketValueChangePercent: parseNum(json['marketValueChangePercent']),
    percentageOfPortfolio: parseNum(json['percentageOfPortfolio']),
    priceChangeAmount: parseNum(json['priceChangeAmountCents']),
    priceChangePercent: parseNum(json['priceChangePercent']),
    cusipIdentifier: json['cusipIdentifier'] as String,
    securityDescription: json['securityDescription'] as String,
    tickerSymbol: json['tickerSymbol'] as String?,
    underlyingCusipIdentifier: json['underlyingCusipIdentifier'] as String?,
    underlyingTickerSymbol: json['underlyingTickerSymbol'] as String?,
  );

  /// Snapshot date for this holding; `null` when the fixture omits it or
  /// sends an unparseable value.
  final DateTime? asOfDate;

  /// Prior session's closing price per unit.
  final double closingPrice;

  /// Change in value since the prior close, in base currency.
  final double dailyChangeAmount;

  /// Change in value since the prior close, as a percentage.
  final double dailyChangePercent;

  /// Current intraday market price per unit.
  final double marketPrice;

  /// Change in total market value since the prior close.
  final double marketValueChange;

  /// Change in total market value since the prior close, as a percentage.
  final double marketValueChangePercent;

  /// Percentage of the account's total portfolio this holding represents.
  final double percentageOfPortfolio;

  /// Change in price since the prior close.
  final double priceChangeAmount;

  /// Change in price since the prior close, as a percentage.
  final double priceChangePercent;

  /// CUSIP identifier for the security (e.g. "037833100").
  final String cusipIdentifier;

  /// Full security description (e.g. "Apple Inc.").
  final String securityDescription;

  /// Exchange ticker symbol. Null for non-equity holdings (bonds, cash).
  final String? tickerSymbol;

  /// CUSIP of the underlying security, for derivative holdings.
  final String? underlyingCusipIdentifier;

  /// Ticker of the underlying security, for derivative holdings.
  final String? underlyingTickerSymbol;

  /// Whether today's price movement is flat or positive.
  bool get isGain => dailyChangeAmount >= 0;
}
