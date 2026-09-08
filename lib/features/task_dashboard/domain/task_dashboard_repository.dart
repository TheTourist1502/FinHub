import 'package:finhub/features/task_dashboard/domain/models/task_dashboard_summary.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';

/// Closed tasks requested per `GET /v1/tasks/closed` page.
///
/// Also the yardstick for "was that the last page?": a page that comes back
/// shorter than this has exhausted the list, regardless of what the summary's
/// count claimed.
const int closedTasksPageSize = 50;

/// Abstract contract for task dashboard data operations.
///
/// `data/` provides the concrete implementation; `presentation/` depends only
/// on this interface so the data source can be swapped in tests.
abstract interface class ITaskDashboardRepository {
  /// Returns the non-closed tasks plus the server's closed-task count.
  Future<TaskDashboardSummary> getTasks();

  /// Returns one page of closed tasks, oldest page first.
  ///
  /// [startPage] is one-based, so the first page is `startPage: 1`; the
  /// endpoint rejects `0` with a 400.
  /// [endPage] defaults to [startPage] — the range is inclusive, so passing a
  /// larger value fetches several pages in one request. [pageSize] applies to
  /// each page in the range.
  Future<List<TaskItem>> getClosedTasks({
    required int startPage,
    int? endPage,
    int pageSize = closedTasksPageSize,
  });
}
