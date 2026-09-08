import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:flutter/foundation.dart';

/// Immutable UI state owned by `TaskDashboardNotifier`.
///
/// Holds two lists that arrive from two different endpoints: [summaryTasks]
/// comes back whole from `GET /v1/tasks/summary`, while [closedTasks]
/// accumulates a page at a time from `GET /v1/tasks/closed`. Only the closed
/// half paginates, so every pagination field here describes it.
///
/// The initial async loading / initial error states are represented by
/// [AsyncValue] wrapping this class in the Riverpod layer; this model only
/// appears inside `AsyncData`.
@immutable
class TaskDashboardState {
  /// Creates a [TaskDashboardState].
  const TaskDashboardState({
    required this.summaryTasks,
    required this.closedTasks,
    required this.closedTotalCount,
    required this.closedPagesLoaded,
    this.isLoadingMoreClosed = false,
    this.closedPageWasShort = false,
    this.closedPaginationError,
  });

  /// Overdue, today, upcoming and open tasks — the whole summary response.
  final List<TaskItem> summaryTasks;

  /// Closed tasks accumulated across every page loaded so far, in server order.
  final List<TaskItem> closedTasks;

  /// Total closed tasks on the server, taken from the summary's `closedTasks`.
  ///
  /// Stays constant while paginating; it is what [hasMoreClosed] counts
  /// towards, so the paginator stops without needing an end-of-list flag from
  /// the closed endpoint.
  final int closedTotalCount;

  /// How many closed pages have been loaded successfully.
  ///
  /// A count, not a page number: the endpoint numbers pages from 1, so the
  /// next page to request is this plus one. A failed page is not counted, so
  /// a retry re-requests it rather than stepping over it.
  final int closedPagesLoaded;

  /// `true` while a closed-task page request is in-flight.
  final bool isLoadingMoreClosed;

  /// `true` once a closed page came back shorter than the requested page size.
  ///
  /// A short page means the server ran out of rows, which overrides
  /// [closedTotalCount]. Without it, a count that over-reports (or a page that
  /// returns nothing) would leave [hasMoreClosed] permanently `true` and let
  /// the scroll listener request the same empty page forever.
  final bool closedPageWasShort;

  /// Non-null when the most recent closed-page request failed.
  ///
  /// Cleared at the start of the next attempt. The initial-load error is
  /// represented by `AsyncError`, not here.
  final AppError? closedPaginationError;

  /// Every loaded task, whatever endpoint it came from.
  ///
  /// The two sources never overlap — the summary no longer returns closed
  /// rows — so this is a plain concatenation with no de-duplication needed.
  List<TaskItem> get allTasks => [...summaryTasks, ...closedTasks];

  /// Whether another closed page is worth requesting.
  bool get hasMoreClosed => !closedPageWasShort && closedTasks.length < closedTotalCount;

  /// Returns a copy of this state with selected fields replaced.
  ///
  /// Use [clearPaginationError] to set [closedPaginationError] back to `null`
  /// (the standard `field ?? old` pattern cannot express explicit-null intent).
  TaskDashboardState copyWith({
    List<TaskItem>? summaryTasks,
    List<TaskItem>? closedTasks,
    int? closedTotalCount,
    int? closedPagesLoaded,
    bool? isLoadingMoreClosed,
    bool? closedPageWasShort,
    AppError? closedPaginationError,
    bool clearPaginationError = false,
  }) => TaskDashboardState(
    summaryTasks: summaryTasks ?? this.summaryTasks,
    closedTasks: closedTasks ?? this.closedTasks,
    closedTotalCount: closedTotalCount ?? this.closedTotalCount,
    closedPagesLoaded: closedPagesLoaded ?? this.closedPagesLoaded,
    isLoadingMoreClosed: isLoadingMoreClosed ?? this.isLoadingMoreClosed,
    closedPageWasShort: closedPageWasShort ?? this.closedPageWasShort,
    closedPaginationError: clearPaginationError ? null : (closedPaginationError ?? this.closedPaginationError),
  );
}
