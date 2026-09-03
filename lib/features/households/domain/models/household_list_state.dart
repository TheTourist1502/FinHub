import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/features/households/domain/models/household_detail.dart';

/// Immutable UI state owned by [HouseholdsNotifier].
///
/// Tracks the accumulated household list, the opaque cursor for the next API
/// page, an in-progress pagination flag, and any pagination-level error that
/// occurred after the initial load succeeded.
///
/// The initial async loading / initial error states are represented by
/// [AsyncValue] wrapping this class in the Riverpod layer; this model only
/// appears inside [AsyncData].
class HouseholdListState {
  /// Creates a [HouseholdListState].
  const HouseholdListState({
    required this.households,
    required this.totalCount,
    required this.shouldLazyLoadData,
    this.nextCursor,
    this.isLoadingMore = false,
    this.paginationError,
  });

  /// All households accumulated across every loaded page, in server order.
  ///
  /// The presentation layer applies search filtering and sorting over this
  /// list before rendering.
  final List<HouseholdDetail> households;

  /// Total number of households available on the server across all pages.
  ///
  /// Comes from the API's `totalCount` key and stays constant while
  /// paginating — render this in the count header instead of
  /// [households.length] so the number doesn't grow as pages load.
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
  /// Cleared automatically at the start of the next [loadMore] or [refresh]
  /// attempt. The initial-load error is represented by [AsyncError], not here.
  final AppError? paginationError;

  /// Whether the dataset needs more than one page.
  ///
  /// Set once from the first unfiltered response (`nextCursor != null`) and
  /// carried forward from then on:
  ///
  /// - `true`  — search and sort are sent to the server, and more pages are
  ///   fetched as the user scrolls.
  /// - `false` — every record already arrived, so searching and sorting
  ///   happen in memory and no further request is sent.
  ///
  /// Do not recompute this from a filtered response: with a search active
  /// `nextCursor` only describes the matches, so a narrow query would leave
  /// the list stuck in the in-memory mode.
  final bool shouldLazyLoadData;

  /// Whether a subsequent page exists.
  bool get hasMore => nextCursor != null;

  /// Returns a copy of this state with selected fields replaced.
  ///
  /// Use [clearNextCursor] to set [nextCursor] to `null` (the standard
  /// `field ?? old` pattern cannot express explicit-null intent).
  /// Use [clearPaginationError] similarly for [paginationError].
  HouseholdListState copyWith({
    List<HouseholdDetail>? households,
    int? totalCount,
    bool? shouldLazyLoadData,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? isLoadingMore,
    AppError? paginationError,
    bool clearPaginationError = false,
  }) => HouseholdListState(
    households: households ?? this.households,
    totalCount: totalCount ?? this.totalCount,
    shouldLazyLoadData: shouldLazyLoadData ?? this.shouldLazyLoadData,
    nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    paginationError: clearPaginationError ? null : (paginationError ?? this.paginationError),
  );
}
