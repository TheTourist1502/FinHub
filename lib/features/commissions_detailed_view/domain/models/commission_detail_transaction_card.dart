import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// A single transaction line within a commission detail record.
///
/// Maps one entry of the `data` array returned by
/// `GET /v1/commissions/details?accountId=`.
@immutable
class CommissionDetailTransactionCard {
  /// Creates a [CommissionDetailTransactionCard].
  const CommissionDetailTransactionCard({
    required this.id,
    required this.accountId,
    required this.tradeId,
    required this.securityName,
    required this.transactionType,
    required this.quantity,
    required this.unitPrice,
    required this.commissionEarned,
    required this.transactionAmount,
    this.tradeDate,
    this.tickerSymbol,
  });

  /// Deserialises from a raw JSON map.
  ///
  /// Despite the `Cents` suffix, `unitPriceCents`, `commissionEarnedCents`
  /// and `investmentAmountCents` carry dollar amounts — they are parsed
  /// as-is, with no division by 100.
  factory CommissionDetailTransactionCard.fromJson(Map<String, dynamic> json) {
    return CommissionDetailTransactionCard(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      tradeId: json['tradeId'] as String,
      securityName: json['securityName'] as String,
      tickerSymbol: json['tickerSymbol'] as String?,
      transactionType: json['transactionType'] as String,
      quantity: parseNum(json['quantity']),
      unitPrice: parseNum(json['unitPriceCents']),
      commissionEarned: parseNum(json['commissionEarnedCents']),
      transactionAmount: parseNum(json['investmentAmountCents']),
      tradeDate: parseOptionalDateTime(json['tradeDate']),
    );
  }

  /// Unique transaction identifier.
  final String id;

  /// Account identifier this transaction belongs to.
  final String accountId;

  /// Trade identifier (e.g. "TRD-AC300001-010").
  final String tradeId;

  /// Full security name (e.g. "Apple Inc.").
  final String securityName;

  /// Ticker symbol (e.g. "AAPL"). Not all securities have one.
  final String? tickerSymbol;

  /// Transaction type — "BUY", "SELL", etc.
  final String transactionType;

  /// Number of shares/units traded.
  final double quantity;

  /// Price per unit at time of transaction, in USD.
  final double unitPrice;

  /// Commission earned on this transaction, in USD.
  final double commissionEarned;

  /// Total invested amount for this transaction, in USD
  /// (`investmentAmountCents`).
  final double transactionAmount;

  /// Calendar date the trade was executed. Pure date — never time-zone
  /// shifted. Null when the backend sent no (or an unparseable) date.
  final DateTime? tradeDate;

  /// Display name combining security name and ticker: "Apple Inc (AAPL)".
  String get displayName => (tickerSymbol?.isNotEmpty ?? false) ? '$securityName ($tickerSymbol)' : securityName;
}
