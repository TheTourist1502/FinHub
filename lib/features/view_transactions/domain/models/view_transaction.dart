import 'package:finhub/core/utils/json_parsing.dart';

/// Domain model representing a single transaction in the FA's transaction history.
///
/// This is the canonical model for the `view_transactions` feature, and the
/// shape every other transactions list converts into before rendering a
/// [TransactionCard] or the detail sheet. It carries the full field set of the
/// transactions endpoints; fields the backend omits on cash movements and
/// corporate actions are nullable.
class Transaction {
  /// Creates a [Transaction].
  const Transaction({
    required this.transactionId,
    required this.accountId,
    required this.transactionType,
    required this.amount,
    required this.accountName,
    required this.accountType,
    required this.securityName,
    required this.quantity,
    required this.unitPrice,
    this.transactionDate,
    this.tickerSymbol,
    this.assetClass,
    this.transactionDescription,
    this.sourceId,
    this.asOfDate,
  });

  /// Creates a [Transaction] from the transactions API response (camelCase
  /// JSON). Despite their `Cents` suffix, `unitPriceCents` and `amountCents`
  /// already carry dollar amounts, so they are parsed as-is with no
  /// divide-by-100 conversion.
  ///
  /// The record identifier arrives as `id`. [quantity] arrives as a numeric
  /// string (e.g. `"37.0000"`) and keeps its fractional part — fractional
  /// share counts are normal for mutual funds and cash balances.
  factory Transaction.fromApiJson(Map<String, dynamic> json) => Transaction(
    transactionId: parseString(json['id']),
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
    accountName: parseString(json['accountName']),
    accountType: parseString(json['accountType']),
  );

  /// Unique transaction identifier (the API's `id`).
  final String transactionId;

  /// Upstream custodian identifier for this record. Null when not provided.
  final String? sourceId;

  /// Account that executed this transaction.
  final String accountId;

  /// Transaction type: BUY, SELL, DIVIDEND, or FEE. Empty when the backend
  /// sends no type — the card then shows [transactionDescription] instead of
  /// a type badge.
  final String transactionType;

  /// Name of the traded security (e.g. "Microsoft Corp").
  final String securityName;

  /// Ticker symbol (e.g. "MSFT"), or `null` when this transaction isn't tied
  /// to a specific security.
  final String? tickerSymbol;

  /// Number of units traded. `0` when the transaction has no unit quantity.
  final double quantity;

  /// Price per unit at execution in USD. `0` when not applicable.
  final double unitPrice;

  /// Raw monetary amount from the source. For display, prefer [displayAmount].
  final double amount;

  /// Execution date of the transaction (from `tradeDate`); `null` when the
  /// backend omits it or sends an unparseable value.
  ///
  /// A pure trade date — never convert it to local time, since that can shift
  /// the calendar day.
  final DateTime? transactionDate;

  /// Free-text description of the transaction. Null when not provided.
  final String? transactionDescription;

  /// Position date this record was reported against (`"2026-08-07"`); `null`
  /// when absent or unparseable.
  ///
  /// A pure calendar date with no time component — never time-zone convert it
  /// for display, since that risks shifting the day.
  final DateTime? asOfDate;

  /// Account name returned by the API (maps to the household display name).
  final String accountName;

  /// Account type (e.g. "IRA", "Brokerage", "Joint", "Education").
  final String accountType;

  /// Asset class of the traded security (e.g. "ETF", "Mutual Fund").
  final String? assetClass;

  /// The monetary amount to display: the raw signed [amount] from the source.
  ///
  /// The sign is kept, so an outflow renders with a leading minus in addition
  /// to the direction its type badge conveys.
  double get displayAmount => amount;

  /// Returns a copy of this [Transaction] with the given fields replaced.
  Transaction copyWith({
    String? transactionId,
    String? sourceId,
    String? accountId,
    String? transactionType,
    String? securityName,
    String? tickerSymbol,
    double? quantity,
    double? unitPrice,
    double? amount,
    DateTime? transactionDate,
    String? transactionDescription,
    DateTime? asOfDate,
    String? accountName,
    String? accountType,
    String? assetClass,
  }) => Transaction(
    transactionId: transactionId ?? this.transactionId,
    sourceId: sourceId ?? this.sourceId,
    accountId: accountId ?? this.accountId,
    transactionType: transactionType ?? this.transactionType,
    securityName: securityName ?? this.securityName,
    tickerSymbol: tickerSymbol ?? this.tickerSymbol,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    amount: amount ?? this.amount,
    transactionDate: transactionDate ?? this.transactionDate,
    transactionDescription: transactionDescription ?? this.transactionDescription,
    asOfDate: asOfDate ?? this.asOfDate,
    accountName: accountName ?? this.accountName,
    accountType: accountType ?? this.accountType,
    assetClass: assetClass ?? this.assetClass,
  );
}
