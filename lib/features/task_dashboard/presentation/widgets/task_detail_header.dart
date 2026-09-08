import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_item_due_row.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_item_icon_circle.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_status_avatar.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Top block of the task detail sheet: icon circle beside the account line,
/// task type heading and due date, closed by a divider.
class TaskDetailHeader extends StatelessWidget {
  /// Creates a [TaskDetailHeader] for [task].
  const TaskDetailHeader({required this.task, super.key});

  /// The task being described.
  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // Overdue tasks read in the error colour; anything dated shows a calendar.
    final isOverdue = task.category == TaskCategory.overdue;
    final isUpcoming =
        task.category == TaskCategory.upcoming ||
        task.category == TaskCategory.open ||
        task.category == TaskCategory.closed;
    final dueLabel = taskDueLabel(context, task.dueDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Same avatar the list card shows, so tapping "View" never swaps
            // the icon or its colour out from under the user.
            TaskStatusAvatar(
              status: task.workflowStatus,
              iconSize: 28,
              fallbackIcon: taskItemFallbackIcon(task.icon),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AccountLine(text: _accountLabel(task)),
                    _TaskTypeTitle(text: task.type ?? ''),
                    // Hidden outright when the task has no due date — the row
                    // exists to state a deadline, so with none there is
                    // nothing to say.
                    if (dueLabel != null) ...[
                      const SizedBox(height: 4),
                      _DueLine(
                        icon: isUpcoming ? Mdi.calendar_outline : Mdi.clock_outline,
                        color: isOverdue ? colors.statusErrorText : colors.textSecondary,
                        label: dueLabel,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Divider(height: 1, thickness: 1, color: colors.borderSubtle),
        ),
      ],
    );
  }
}

/// Builds the uppercase `ACCOUNT • TYPE` line, dropping the type when absent.
String _accountLabel(TaskItem task) {
  final name = task.accountDisplayName.toUpperCase();
  final type = task.faAccountType;
  return (type?.isEmpty ?? true) ? name : '$name • ${type!.toUpperCase()}';
}

/// Small uppercase account identifier above the task title.
class _AccountLine extends StatelessWidget {
  const _AccountLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.cardMeta.copyWith(
        color: context.appColors.textSecondary,
        fontWeight: FontWeight.w600,
        fontSize: 11,
        letterSpacing: 0.55,
      ),
    );
  }
}

/// Prominent task type heading.
class _TaskTypeTitle extends StatelessWidget {
  const _TaskTypeTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.pageTitle.copyWith(
        color: context.appColors.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 20,
        height: 1.4,
      ),
    );
  }
}

/// Icon plus due-date text, tinted by the caller to signal overdue state.
class _DueLine extends StatelessWidget {
  const _DueLine({required this.icon, required this.color, required this.label});

  final String icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Iconify(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
