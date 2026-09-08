import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:flutter/foundation.dart';

/// One `GET /v1/tasks/summary` response, split into the rows it carries and
/// the closed-task count it only reports.
///
/// The summary endpoint stopped returning closed rows: `closedTaskList` is
/// always empty while `closedTasks` still holds the real total. That total is
/// the only thing that says how many closed pages exist, so it is carried here
/// and used to drive pagination against `GET /v1/tasks/closed`.
@immutable
class TaskDashboardSummary {
  /// Creates a [TaskDashboardSummary].
  const TaskDashboardSummary({required this.tasks, required this.closedTotalCount});

  /// Every non-closed task in the response — overdue, today, upcoming, open.
  ///
  /// Closed tasks are deliberately absent; they are fetched a page at a time
  /// through `ITaskDashboardRepository.getClosedTasks`.
  final List<TaskItem> tasks;

  /// `closedTasks` — total closed tasks on the server, across all pages.
  ///
  /// Defaults to `0` when the key is missing, which reads as "no closed
  /// tasks" and stops the paginator before it issues a request.
  final int closedTotalCount;
}
