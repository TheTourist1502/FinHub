import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_detail_info_section.dart';
import 'package:flutter/material.dart';

/// Placeholder rendered when a task field comes back empty or null.
const _kEmptyValue = '—';

/// The three narrative blocks of the task detail sheet: description, pending
/// action, and workflow progress.
class TaskDetailSummary extends StatelessWidget {
  /// Creates a [TaskDetailSummary] for [task].
  const TaskDetailSummary({required this.task, super.key});

  /// The task being described.
  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TaskDetailInfoSection(
          heading: l10n.taskDashboardDetailDescription,
          body: _orDash(task.description),
        ),
        const SizedBox(height: 24),
        TaskDetailInfoSection(
          heading: l10n.taskDashboardDetailActionPending,
          body: _orDash(task.pendingAction),
        ),
        const SizedBox(height: 24),
        TaskDetailInfoSection(
          heading: l10n.taskDashboardDetailWorkflowProgress,
          body: _orDash(task.workflowStatus),
        ),
      ],
    );
  }
}

/// Returns [value], or the dash placeholder when it is null or empty.
String _orDash(String? value) => (value?.isEmpty ?? true) ? _kEmptyValue : value!;
