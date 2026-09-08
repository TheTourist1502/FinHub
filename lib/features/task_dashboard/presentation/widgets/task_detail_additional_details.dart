import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/utils/date_display_formatter.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_detail_cell.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_detail_grid.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_detail_section_label.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Placeholder rendered when a task field comes back empty or null.
const _kEmptyValue = '—';

/// Trailing metadata block of the task detail sheet: reference id, account
/// number, and creation date in a two-column grid.
class TaskDetailAdditionalDetails extends StatelessWidget {
  /// Creates a [TaskDetailAdditionalDetails] for [task].
  const TaskDetailAdditionalDetails({required this.task, super.key});

  /// The task being described.
  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final createdDate = task.createdDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 16),
        TaskDetailSectionLabel(text: l10n.taskDashboardDetailAdditionalDetails),
        TaskDetailGrid(
          cells: [
            TaskDetailCell(label: l10n.taskDashboardDetailReferenceId, value: task.taskId),
            TaskDetailCell(
              label: l10n.taskDashboardDetailAccountNumber,
              value: (task.accountNumber?.isEmpty ?? true) ? _kEmptyValue : task.accountNumber!,
            ),
            // Dropped from the grid entirely when absent. A creation date is
            // either a real timestamp or nothing — a dash in its place reads
            // like the record has no history.
            if (createdDate != null)
              TaskDetailCell(
                label: l10n.taskDashboardDetailCreatedOn,
                value: DateFormat('MMM d, yyyy').formatLocal(createdDate),
              ),
          ],
        ),
      ],
    );
  }
}
