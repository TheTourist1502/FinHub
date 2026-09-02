import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// A single transaction recorded against an account.
@immutable
class AccountTransaction {
  /// Creates an [AccountTransaction].
  const AccountTransaction({
    required this.transactionId,
    required this.accountId,
    required this.transactionType,
    required this.securityName,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    this.transactionDate,
    this.tickerSymbol,
    this.assetClass,
    this.transactionDescription,
    this.sourceId,
    this.asOfDate,
    this.accountName,
    this.accountType,
  });

  /// Deserialises from the live API response (camelCase keys).
  ///
  /// Despite their `*Cents` suffix, `unitPriceCents` and `amountCents` carry
  /// dollar amounts — they are parsed as-is, with no division by 100.
  ///
  /// Date comes from `tradeDate`. Numeric fields may arrive as [num] or
  /// [String]; `quantity` and `unitPriceCents` are null for cash transactions
  /// (deposits, dividends, fees) and default to 0. The identifier arrives as
  /// `id` on the live API, with `transactionId` kept as a fallback.
  factory AccountTransaction.fromApiJson(Map<String, dynamic> json) => AccountTransaction(
    transactionId: parseString(json['id'] ?? json['transactionId']),
    sourceId: parseOptionalString(json['sourceId']),
    accountId: parseString(json['accountId']),
    transactionType: parseString(json['transactionType']),
    securityName: parseString(json['securityName']),
    tickerSymbol: parseOptionalString(json['tickerSymbol']),
    assetClass: parseOptionalString(json['assetClass']),
    transactionDescription: parseOptionalString(json['transactionDescription']),
    quantity: parseNum(json['quantity']),
    unitPrice: parseNum(json['unitPriceCents']),
    amount: parseNum(json['amountCents']),
    transactionDate: parseOptionalDateTime(json['tradeDate']),
    asOfDate: parseOptionalDateTime(json['asOfDate']),
    accountName: parseOptionalString(json['accountName']),
    accountType: parseOptionalString(json['accountType']),
  );

  /// Unique transaction identifier (the API's `id`).
  final String transactionId;

  /// Upstream custodian identifier for this record. Null when not provided.
  final String? sourceId;

  /// Account this transaction belongs to.
  final String accountId;

  /// Type of transaction: BUY, SELL, DIVIDEND, DEPOSIT, FEE, etc. Empty when
  /// the backend sends no type.
  final String transactionType;

  /// Full name of the security (e.g. "Amazon.com Inc").
  final String securityName;

  /// Ticker symbol. Null for cash transactions such as deposits.
  final String? tickerSymbol;

  /// Number of units traded. `0` when the transaction has no unit quantity.
  final double quantity;

  /// Price per unit at the time of the transaction in USD.
  final double unitPrice;

  /// Total transaction amount in USD.
  final double amount;

  /// Date the transaction was executed (from `tradeDate`), or `null` when the
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

  /// Asset class of the traded security (e.g. "ETF"). Null when not provided.
  final String? assetClass;

  /// Display name of the account (e.g. "Hernandez Family Brokerage"). Null when not provided.
  final String? accountName;

  /// Account type label (e.g. "BROKERAGE"). Null when not provided.
  final String? accountType;

  /// Whether this transaction represents a cash inflow (SELL, DIVIDEND, DEPOSIT).
  bool get isIncoming => transactionType == 'SELL' || transactionType == 'DIVIDEND' || transactionType == 'DEPOSIT';

  /// Display amount — the raw signed [amount], so a negative value renders
  /// with a leading minus rather than relying on [isIncoming] alone.
  double get displayAmount => amount;
}
