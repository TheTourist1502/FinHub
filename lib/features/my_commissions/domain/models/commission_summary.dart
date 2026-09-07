import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// A single commission summary record for an account.
@immutable
class CommissionSummary {
  /// Creates a [CommissionSummary].
  const CommissionSummary({
    required this.commissionSummaryId,
    required this.accountId,
    required this.accountNumber,
    required this.accountHolderName,
    required this.commissionEarned,
    this.asOfDate,
    this.ytdCommissionChange,
    this.ytdCommissionChangePercentage,
  });

  /// Creates a [CommissionSummary] from one entry of the
  /// `GET /v1/commissions/summary` API response.
  ///
  /// Each entry returns its own `accountName` / `accountNumber` identity
  /// fields directly, so no external enrichment is required.
  ///
  /// Despite its name, `commissionEarnedCents` already carries a dollar
  /// amount — it is read as-is with no division by 100.
  ///
  /// [ytdCommissionChange] and [ytdCommissionChangePercentage] are read from
  /// the `ytdCommissionChange` / `ytdCommissionChangePercentage` keys, and
  /// default to `0` when the API omits them.
  ///
  /// [asOfDate] parses through [parseOptionalDateTime] rather than a hard
  /// `DateTime.parse`, so a missing or malformed value cannot fail the whole
  /// page of summaries — it simply yields `null`.
  factory CommissionSummary.fromApiJson(Map<String, dynamic> json) {
    return CommissionSummary(
      commissionSummaryId: json['id'] as String,
      accountId: json['accountId'] as String?,
      accountNumber: json['accountNumber'] as String?,
      accountHolderName: json['accountName'] as String? ?? json['accountId'] as String? ?? '',
      commissionEarned: parseNum(json['commissionEarnedCents']),
      asOfDate: parseOptionalDateTime(json['asOfDate']),
      ytdCommissionChange: parseNum(json['ytdCommissionChange']),
      ytdCommissionChangePercentage: parseNum(json['ytdCommissionChangePercentage']),
    );
  }

  /// Unique identifier for this commission summary record.
  final String commissionSummaryId;

  /// Account identifier.
  final String? accountId;

  /// Account number shown in the UI (e.g. "ACC00128").
  final String? accountNumber;

  /// Full name of the account holder.
  final String accountHolderName;

  /// Commission earned from this transaction, in USD.
  final double commissionEarned;

  /// Snapshot instant the commission figures were computed at; `null` when
  /// the API omits it or sends an unparseable value.
  ///
  /// Sent by the backend in UTC — format it for display with
  /// `DateFormat.formatLocal()` from `lib/core/utils/date_display_formatter.dart`,
  /// never a bare `.format()`.
  final DateTime? asOfDate;

  /// YTD change in commission amount (absolute dollar value). Defaults to `0`
  /// when the API does not return `ytdCommissionChange`.
  final double? ytdCommissionChange;

  /// YTD change in commission as a percentage. Defaults to `0` when the API
  /// does not return `ytdCommissionChangePercentage`.
  final double? ytdCommissionChangePercentage;
}

/// A single page of commission summaries returned by the cursor-based
/// `GET /v1/commissions/summary` endpoint.
///
/// The frontend must never generate or modify [nextCursor] — it is an opaque
/// value owned by the server. Pass it verbatim to the next
/// `MyCommissionsRepository.getCommissionSummary` call to fetch the next
/// page.
class CommissionTransactionPage {
  /// Creates a [CommissionTransactionPage].
  const CommissionTransactionPage({required this.transactions, required this.nextCursor, required this.totalCount});

  /// The commission summaries returned in this page.
  final List<CommissionSummary> transactions;

  /// Opaque cursor to pass in the next request, or `null` when this is the
  /// last page and no further records exist.
  final String? nextCursor;

  /// Total number of commission summaries available on the server across
  /// all pages (the `totalCount` key in the response). Stays constant while
  /// paginating.
  final int totalCount;

  /// Whether a subsequent page of summaries is available.
  bool get hasMore => nextCursor != null;
}

/// Immutable UI state owned by `CommissionsDetailsNotifier`.
///
/// Tracks the accumulated commission summary list, the opaque cursor for
/// the next API page, an in-progress pagination flag, and any
/// pagination-level error that occurred after the initial load succeeded.
///
/// The initial async loading / initial error states are represented by
/// [AsyncValue] wrapping this class in the Riverpod layer; this model only
/// appears inside `AsyncData`.
class CommissionTransactionsListState {
  /// Creates a [CommissionTransactionsListState].
  const CommissionTransactionsListState({
    required this.transactions,
    required this.totalCount,
    this.nextCursor,
    this.isLoadingMore = false,
    this.paginationError,
  });

  /// All commission summaries accumulated across every loaded page, in
  /// server order.
  ///
  /// The presentation layer applies search filtering over this list before
  /// rendering.
  final List<CommissionSummary> transactions;

  /// Total number of commission summaries available on the server across
  /// all pages.
  ///
  /// Comes from the API's `totalCount` key and stays constant while
  /// paginating.
  final int totalCount;

  /// Opaque cursor to fetch the next page, or `null` when all pages are
  /// exhausted. Never modify this value — pass it verbatim to the API.
  final String? nextCursor;

  /// `true` while a pagination request is in-flight.
  ///
  /// The UI shows a bottom loading indicator and suppresses duplicate calls
  /// while this flag is set.
  final bool isLoadingMore;

  /// Non-null when the most recent pagination request failed.
  ///
  /// Cleared automatically at the start of the next `loadMore` or `refresh`
  /// attempt. The initial-load error is represented by `AsyncError`, not here.
  final AppError? paginationError;

  /// Whether a subsequent page exists.
  bool get hasMore => nextCursor != null;

  /// Returns a copy of this state with selected fields replaced.
  ///
  /// Use [clearNextCursor] to set [nextCursor] to `null` (the standard
  /// `field ?? old` pattern cannot express explicit-null intent).
  /// Use [clearPaginationError] similarly for [paginationError].
  CommissionTransactionsListState copyWith({
    List<CommissionSummary>? transactions,
    int? totalCount,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? isLoadingMore,
    AppError? paginationError,
    bool clearPaginationError = false,
  }) => CommissionTransactionsListState(
    transactions: transactions ?? this.transactions,
    totalCount: totalCount ?? this.totalCount,
    nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    paginationError: clearPaginationError ? null : (paginationError ?? this.paginationError),
  );
}
