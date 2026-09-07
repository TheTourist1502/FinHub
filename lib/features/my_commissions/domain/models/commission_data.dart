import 'package:finhub/core/utils/json_parsing.dart';
import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:flutter/foundation.dart';

/// Represents one of the top-performing accounts by total commission earned.
@immutable
class TopAccount {
  /// Creates a [TopAccount].
  const TopAccount({
    required this.rank,
    required this.accountHolderName,
    required this.accountNumberMasked,
    required this.accountId,
    required this.totalCommission,
  });

  /// Creates a [TopAccount] from one entry of the `topAccounts` array in the
  /// `GET /v1/commissions/top-accounts` API response.
  ///
  /// [rank] is derived from the entry's position in the list — the API
  /// returns accounts pre-sorted by commission earned, highest first.
  ///
  /// Despite its name, `totalCommissionEarnedCents` already carries a dollar
  /// amount — it is read as-is with no division by 100.
  factory TopAccount.fromApiJson(Map<String, dynamic> json, {required int rank}) {
    return TopAccount(
      rank: rank,
      accountHolderName: json['accountName'] as String,
      accountNumberMasked: json['accountNumber'] as String,
      accountId: json['accountId'] as String,
      totalCommission: parseNum(json['totalCommissionEarnedCents']),
    );
  }

  /// Ordinal rank (1 = highest commission).
  final int rank;

  /// Full name of the account holder.
  final String accountHolderName;

  /// Masked account number (e.g. "XXXXX1456").
  final String accountNumberMasked;

  /// Unique account identifier.
  final String accountId;

  /// Total commission earned from this account, in USD.
  final double totalCommission;
}

/// The full response shape of `GET /v1/commissions/top-accounts`.
///
/// Carries the ranked account list alongside the aggregate counts and total
/// commission used to drive the My Commissions summary card and overview KPIs.
@immutable
class TopAccountsSummary {
  /// Creates a [TopAccountsSummary].
  const TopAccountsSummary({
    required this.topAccounts,
    required this.accountsContributingCount,
    required this.householdsContributingCount,
    required this.totalCommission,
  });

  /// Deserialises from the `GET /v1/commissions/top-accounts` API response.
  ///
  /// Despite its name, `totalCommissionCents` already carries a dollar
  /// amount — it is read as-is with no division by 100.
  factory TopAccountsSummary.fromApiJson(Map<String, dynamic> json) {
    final list = (json['topAccounts'] as List<dynamic>).cast<Map<String, dynamic>>();

    return TopAccountsSummary(
      topAccounts: [
        for (var i = 0; i < list.length; i++) TopAccount.fromApiJson(list[i], rank: i + 1),
      ],
      accountsContributingCount: parseInt(json['accountsContributingCount']),
      householdsContributingCount: parseInt(json['householdsContributingCount']),
      totalCommission: parseNum(json['totalCommissionCents']),
    );
  }

  /// Accounts ranked by total commission earned, highest first.
  final List<TopAccount> topAccounts;

  /// Number of accounts contributing to the commission total.
  final int accountsContributingCount;

  /// Number of households contributing to the commission total.
  final int householdsContributingCount;

  /// Cumulative commission earned across all eligible accounts, in USD.
  final double totalCommission;
}

/// Aggregate commission data for the authenticated financial advisor.
///
/// Transaction-level records are not included here — the Details tab loads
/// those separately via `commissionsDetailsNotifierProvider` since they are
/// paginated independently of this summary.
@immutable
class CommissionData {
  /// Creates a [CommissionData].
  const CommissionData({
    required this.commissionEarned,
    required this.householdsContributing,
    required this.accountsContributing,
    required this.commissionsTrend,
    required this.topAccounts,
  });

  /// Cumulative commission earned across all eligible accounts, in USD.
  ///
  /// Sourced from `totalCommissionCents` on `GET /v1/commissions/top-accounts`.
  final double commissionEarned;

  /// Number of households contributing to the commission total.
  final int householdsContributing;

  /// Number of accounts contributing to the commission total.
  final int accountsContributing;

  /// Time-series trend data for charting commission history — reuses the
  /// dashboard's [FaCommissionEntry] shape (`GET /v1/commissions/history`).
  final List<FaCommissionEntry> commissionsTrend;

  /// Top accounts ranked by total commission earned.
  final List<TopAccount> topAccounts;
}
