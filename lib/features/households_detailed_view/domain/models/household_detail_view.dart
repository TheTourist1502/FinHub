import 'package:finhub/core/utils/json_parsing.dart';
import 'package:finhub/features/accounts/domain/models/account.dart';
import 'package:flutter/foundation.dart';

/// Asset allocation entry for a household detail view.
@immutable
class HouseholdDetailAllocation {
  /// Creates a [HouseholdDetailAllocation].
  const HouseholdDetailAllocation({
    required this.assetClass,
    required this.marketValue,
    required this.allocationPercentage,
  });

  /// Deserialises from the live API response (camelCase keys, string percentage).
  ///
  /// Despite its name, `marketValueCents` carries a dollar amount — it is
  /// parsed as-is, with no division by 100.
  factory HouseholdDetailAllocation.fromApiJson(Map<String, dynamic> json) => HouseholdDetailAllocation(
    assetClass: json['assetClass'] as String,
    marketValue: parseNum(json['marketValueCents']),
    allocationPercentage: parseNum(json['allocationPercentage']),
  );

  /// Asset class name (e.g. "EQUITIES", "BONDS").
  final String assetClass;

  /// Total market value for this asset class in USD.
  final double marketValue;

  /// Percentage of the household's total AUM in this class.
  final double allocationPercentage;
}

/// A single transaction associated with a household.
@immutable
class HouseholdDetailTransaction {
  /// Creates a [HouseholdDetailTransaction].
  const HouseholdDetailTransaction({
    required this.transactionId,
    required this.accountId,
    required this.transactionType,
    required this.securityName,
    required this.tickerSymbol,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    required this.accountName,
    required this.accountType,
    this.assetClass,
    this.transactionDescription,
    this.sourceId,
    this.transactionDate,
    this.asOfDate,
  });

  /// Deserialises from the live API response (camelCase keys).
  ///
  /// The record identifier arrives as `id` (with `transactionId` accepted as
  /// a fallback for older payloads). Despite the `Cents` suffix,
  /// `unitPriceCents` and `amountCents` carry dollar amounts — they are parsed
  /// as-is, with no division by 100.
  factory HouseholdDetailTransaction.fromApiJson(Map<String, dynamic> json) => HouseholdDetailTransaction(
    transactionId: parseString(json['id'] ?? json['transactionId']),
    sourceId: parseOptionalString(json['sourceId']),
    accountId: parseString(json['accountId']),
    transactionType: parseString(json['transactionType']),
    securityName: parseString(json['securityName']),
    tickerSymbol: parseString(json['tickerSymbol']),
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

  /// Account this transaction belongs to.
  final String accountId;

  /// Type: BUY, SELL, DIVIDEND, DEPOSIT, FEE. Empty when the backend sends
  /// no type.
  final String transactionType;

  /// Security name (empty for cash transactions without an underlying).
  final String securityName;

  /// Ticker symbol (empty for cash transactions without an underlying).
  final String tickerSymbol;

  /// Asset class (e.g. "ETF", "Mutual Fund"). Null when not provided.
  final String? assetClass;

  /// Number of units traded. `0` when the transaction has no unit quantity.
  final double quantity;

  /// Price per unit in USD.
  final double unitPrice;

  /// Total transaction amount in USD.
  final double amount;

  /// Date the transaction was executed (from `tradeDate`). Null when the
  /// backend sent no (or an unparseable) date.
  ///
  /// A pure trade date — never convert it to local time.
  final DateTime? transactionDate;

  /// Free-text description of the transaction. Null when not provided.
  final String? transactionDescription;

  /// Position date this record was reported against. Null when the backend
  /// sent no (or an unparseable) date.
  ///
  /// A pure calendar date — never convert it to local time.
  final DateTime? asOfDate;

  /// Display name of the account this transaction belongs to.
  final String accountName;

  /// Account type label (e.g. "IRA", "BROKERAGE", "401K", "ROTH_IRA").
  final String accountType;

  /// Whether this transaction represents a cash inflow (SELL, DIVIDEND, DEPOSIT).
  bool get isIncoming => transactionType == 'SELL' || transactionType == 'DIVIDEND' || transactionType == 'DEPOSIT';

  /// Display amount — the raw signed [amount], so a negative value renders
  /// with a leading minus rather than relying on [isIncoming] alone.
  double get displayAmount => amount;
}

/// Full detail data for a single household, backing the household detail screen.
@immutable
class HouseholdDetailView {
  /// Creates a [HouseholdDetailView].
  const HouseholdDetailView({
    required this.householdId,
    required this.householdName,
    required this.householdCode,
    required this.totalAum,
    required this.aumChange,
    required this.aumChangePercentage,
    required this.accountCount,
    required this.status,
    required this.assetAllocation,
    required this.accounts,
    required this.transactions,
  });

  /// Assembles a [HouseholdDetailView] from the live API responses.
  ///
  /// - [householdJson]    — response body from `GET /v1/households/{id}`.
  /// - [allocationList]   — `data` array from `GET /v1/households/{id}/asset-allocation`.
  /// - [accountList]      — `data` array from `GET /v1/households/{id}/accounts`.
  /// - [transactionList]  — `data` array from `GET /v1/households/{id}/transactions`.
  ///
  /// Despite the `Cents` suffix, `totalAumCents` and `aumChangeCents` carry
  /// dollar amounts — they are parsed as-is, with no division by 100.
  /// [aumChangePercentage] arrives as a numeric string (e.g. `"9.60"`).
  /// The household payload embeds its own `assetAllocation` array; when
  /// present it takes precedence over [allocationList]. [accountCount] maps
  /// from `totalAccounts`, falling back to the length of [accountList].
  factory HouseholdDetailView.fromApiJson({
    required Map<String, dynamic> householdJson,
    required List<Map<String, dynamic>> allocationList,
    required List<Map<String, dynamic>> accountList,
    required List<Map<String, dynamic>> transactionList,
  }) {
    final embeddedAllocations =
        (householdJson['assetAllocation'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? allocationList;
    return HouseholdDetailView(
      householdId: householdJson['householdId'] as String,
      householdName: householdJson['householdName'] as String,
      householdCode: householdJson['householdId'] as String,
      totalAum: parseNum(householdJson['totalAumCents']),
      aumChange: parseNum(householdJson['aumChangeCents']),
      aumChangePercentage: parseNum(householdJson['aumChangePercentage']),
      accountCount: parseInt(householdJson['totalAccounts'], fallback: accountList.length),
      status: householdJson['status'] as String? ?? 'ACTIVE',
      assetAllocation: embeddedAllocations.map(HouseholdDetailAllocation.fromApiJson).toList(),
      accounts: accountList.map(Account.fromApiJson).toList(),
      transactions: transactionList.map(HouseholdDetailTransaction.fromApiJson).toList(),
    );
  }

  /// Unique household identifier.
  final String householdId;

  /// Display name of the household (e.g. "The Anderson Trust").
  final String householdName;

  /// Short household reference code (e.g. "#882910").
  final String householdCode;

  /// Total assets under management across all accounts in USD.
  final double totalAum;

  /// Absolute AUM change in USD.
  final double aumChange;

  /// AUM change as a percentage (e.g. 9.60).
  final double aumChangePercentage;

  /// Number of accounts in this household.
  final int accountCount;

  /// Household status (e.g. "ACTIVE").
  final String status;

  /// Asset class breakdown for the household.
  final List<HouseholdDetailAllocation> assetAllocation;

  /// All accounts belonging to this household, sorted by current value descending.
  final List<Account> accounts;

  /// Recent transactions across all household accounts.
  final List<HouseholdDetailTransaction> transactions;

  /// Whether the AUM change is positive or zero.
  bool get isPositiveReturn => aumChange >= 0;

  /// Top 5 accounts by AUM (current value), for the overview section.
  List<Account> get topAccounts {
    final sorted = [...accounts]..sort((a, b) => b.currentValue.compareTo(a.currentValue));
    return sorted.take(5).toList();
  }
}
