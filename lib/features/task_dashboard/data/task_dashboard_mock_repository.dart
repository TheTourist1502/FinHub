import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/utils/json_parsing.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_dashboard_summary.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:finhub/features/task_dashboard/domain/task_dashboard_repository.dart';

/// [ITaskDashboardRepository] backed by `assets/mock-data/tasks/`.
///
/// The summary fixture carries the four open buckets; closed rows live in
/// their own file and are paged here, since the list screen pages through them.
class TaskDashboardMockRepository implements ITaskDashboardRepository {
  /// Creates the repository over [_source], scoped to [_scope]'s advisor.
  const TaskDashboardMockRepository(this._source, this._scope);

  final MockDataSource _source;
  final DataScope _scope;

  @override
  Future<TaskDashboardSummary> getTasks() async {
    final body = await _source.readScoped('tasks/summary.json', _scope.advisorId) ?? const {};
    return TaskDashboardSummary(
      tasks: _parseSummaryLists(body),
      closedTotalCount: (body['closedTasks'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<List<TaskItem>> getClosedTasks({
    required int startPage,
    int? endPage,
    int pageSize = closedTasksPageSize,
  }) async {
    final body = await _source.readScoped('tasks/closed.json', _scope.advisorId) ?? const {};
    final rows = (body['closedTaskList'] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>();

    // Page numbers are one-based and the range is inclusive, matching the
    // contract the list screen was written against.
    final from = (startPage - 1) * pageSize;
    final to = (endPage ?? startPage) * pageSize;
    if (from >= rows.length) return const [];
    final slice = rows.sublist(from, to > rows.length ? rows.length : to);

    return slice.map((json) => _toTaskItem(json, TaskCategory.closed)).toList();
  }

  List<TaskItem> _parseSummaryLists(Map<String, dynamic> body) {
    List<TaskItem> fromList(dynamic raw, TaskCategory category) =>
        (raw as List<dynamic>? ?? []).cast<Map<String, dynamic>>().map((json) => _toTaskItem(json, category)).toList();

    return [
      ...fromList(body['overdueTaskList'], TaskCategory.overdue),
      ...fromList(body['todayTaskList'], TaskCategory.today),
      ...fromList(body['upcomingTaskList'], TaskCategory.upcoming),
      ...fromList(body['openTaskList'], TaskCategory.open),
    ];
  }

  TaskItem _toTaskItem(Map<String, dynamic> json, TaskCategory category) {
    final dueDate = parseOptionalDateTime(json['dueDate']);
    return TaskItem(
      taskId: json['taskId'] as String,
      type: json['type'] as String?,
      workflowStatus: json['workflowStatus'] as String?,
      slaBreach: json['slaBreach'] as String?,
      relatedRecordId: json['relatedRecordId'] as String?,
      pendingAction: json['pendingAction'] as String?,
      financialAccountName: json['financialAccountName'] as String?,
      financialAccountId: json['financialAccountId'] as String?,
      faAccountType: json['faAccountType'] as String?,
      dueDate: dueDate,
      description: json['description'] as String?,
      createdDate: parseOptionalDateTime(json['createdDate']),
      assignedTo: json['assignedTo'] as String?,
      accountNumber: json['accountNumber'] as String?,
      accountMaintainenceTaskName: json['accountMaintainenceTaskName'] as String?,
      accountMaintainenceId: json['accountMaintainenceId'] as String?,
      category: _effectiveCategory(category, dueDate),
      icon: _iconForType(json['type'] as String? ?? ''),
    );
  }

  /// A task with no due date cannot be overdue, due today, or upcoming — it is
  /// simply open, whichever bucket it arrived in.
  static TaskCategory _effectiveCategory(TaskCategory category, DateTime? dueDate) {
    if (dueDate != null) return category;
    return switch (category) {
      TaskCategory.overdue || TaskCategory.today || TaskCategory.upcoming => TaskCategory.open,
      TaskCategory.open || TaskCategory.closed => category,
    };
  }

  static String _iconForType(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('kyc')) return 'account_outline';
    if (lower.contains('bank') || lower.contains('account')) return 'bank_outline';
    return 'file_document_outline';
  }
}
