import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_item_details.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_item_due_row.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_item_icon_circle.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_item_open_detail.dart';
import 'package:flutter/material.dart';

/// Hairline divider between rows of a grouped card.
const Color _kDividerColor = AppColors.cardGrey50;

const _kDividerDecoration = BoxDecoration(
  border: Border(bottom: BorderSide(color: _kDividerColor)),
);

/// Categories whose due row uses a calendar glyph instead of a clock.
const _kCalendarCategories = <TaskCategory>{
  TaskCategory.upcoming,
  TaskCategory.open,
  TaskCategory.closed,
};

/// Inner layout shared by the standalone card and the grouped row.
///
/// Composes the icon circle, the detail block, and the due row.
class TaskItemRowContent extends StatelessWidget {
  /// Creates a [TaskItemRowContent] for [task].
  const TaskItemRowContent({
    required this.task,
    required this.showDivider,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  /// The task to display.
  final TaskItem task;

  /// Whether a bottom hairline separates this row from the next.
  final bool showDivider;

  /// Inner padding around the row.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final status = task.workflowStatus;
    void onViewTap() => openTaskDetail(context, task);

    return Container(
      decoration: showDivider ? _kDividerDecoration : null,
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskItemIconCircle(iconKey: task.icon, workflowStatus: status),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (status != null)
                  TaskItemStatusDetails(
                    status: status,
                    type: task.type ?? '',
                    subtitle: (task.faAccountType?.isEmpty ?? true)
                        ? task.accountDisplayName
                        : '${task.accountDisplayName} • ${task.faAccountType}',
                    onViewTap: onViewTap,
                  )
                else
                  TaskItemPlainDetails(
                    title: task.accountDisplayName,
                    subtitle: '${task.type ?? ''} • ${task.accountNumber ?? task.taskId}',
                    onViewTap: onViewTap,
                  ),
                // No due date means no due row at all — icon included. A task
                // that never stated when it is due must not show a placeholder
                // in the slot where a deadline would be.
                if (taskDueLabel(context, task.dueDate) case final dueLabel?) ...[
                  const SizedBox(height: 5),
                  TaskItemDueRow(
                    label: dueLabel,
                    isOverdue: task.category == TaskCategory.overdue,
                    useCalendarIcon: _kCalendarCategories.contains(task.category),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
