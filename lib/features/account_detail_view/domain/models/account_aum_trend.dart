import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// A single weekly AUM data point for one account, returned by
/// `GET /v1/accounts/{id}/aum-history`.
@immutable
class AccountAumTrend {
  /// Creates an [AccountAumTrend].
  const AccountAumTrend({
    required this.weekDate,
    required this.aum,
  });

  /// Deserialises from the live API response (camelCase keys).
  ///
  /// Despite its `*Cents` suffix, `aumCents` carries a dollar amount — it is
  /// parsed as-is, with no division by 100.
  factory AccountAumTrend.fromApiJson(Map<String, dynamic> json) => AccountAumTrend(
    weekDate: parseOptionalDateTime(json['weekDate']),
    aum: parseNum(json['aumCents']),
  );

  /// The week-end date for this data point, or `null` when the backend sent
  /// no date. A pure calendar date — never convert it to local time.
  final DateTime? weekDate;

  /// Assets under management in USD for this account as of [weekDate].
  final double aum;
}
