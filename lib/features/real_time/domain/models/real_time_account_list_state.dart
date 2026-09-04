import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/features/real_time/domain/models/real_time_account.dart';

/// Immutable UI state owned by [RealTimeAccountsNotifier].
///
/// Tracks the accumulated, currently-searched account list, the opaque
/// cursor for the next page, an in-progress pagination flag, and any
/// pagination-level error that occurred after the initial load succeeded.
///
/// The initial async loading / initial error states are represented by
/// `AsyncValue` wrapping this class in the Riverpod layer; this model only
/// appears inside `AsyncData`.
class RealTimeAccountListState {
  /// Creates a [RealTimeAccountListState].
  const RealTimeAccountListState({
    required this.accounts,
    required this.totalCount,
    this.nextCursor,
    this.shouldLazyLoadData = true,
    this.isLoadingMore = false,
    this.paginationError,
  });

  /// Accounts accumulated across every loaded page for the current search
  /// term, in server order.
  final List<RealTimeAccount> accounts;

  /// Total number of accounts matching the current search, across all pages.
  final int totalCount;

  /// Opaque cursor to fetch the next page, or `null` when all pages are
  /// exhausted. Never modify this value — pass it verbatim to the repository.
  final String? nextCursor;

  /// Whether the picker runs in server mode.
  ///
  /// Decided once by the first unfiltered response: `true` when it carried a
  /// `nextCursor` (more pages exist), so search and pagination are delegated
  /// to the repository. `false` when the whole dataset arrived in one page —
  /// no further request is ever sent and the picker filters its options in
  /// memory instead.
  final bool shouldLazyLoadData;

  /// `true` while a pagination request is in-flight.
  final bool isLoadingMore;

  /// Non-null when the most recent pagination request failed.
  ///
  /// Cleared automatically at the start of the next pagination or search
  /// attempt. The initial-load error is represented by `AsyncError`, not here.
  final AppError? paginationError;

  /// Whether a subsequent page exists.
  bool get hasMore => nextCursor != null;

  /// Returns a copy of this state with selected fields replaced.
  ///
  /// Use [clearNextCursor] to set [nextCursor] to `null` (the standard
  /// `field ?? old` pattern cannot express explicit-null intent).
  /// Use [clearPaginationError] similarly for [paginationError].
  RealTimeAccountListState copyWith({
    List<RealTimeAccount>? accounts,
    int? totalCount,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? shouldLazyLoadData,
    bool? isLoadingMore,
    AppError? paginationError,
    bool clearPaginationError = false,
  }) => RealTimeAccountListState(
    accounts: accounts ?? this.accounts,
    totalCount: totalCount ?? this.totalCount,
    nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
    shouldLazyLoadData: shouldLazyLoadData ?? this.shouldLazyLoadData,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    paginationError: clearPaginationError ? null : (paginationError ?? this.paginationError),
  );
}
