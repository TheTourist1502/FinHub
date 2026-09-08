import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_item_view_action.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_workflow_chip.dart';
import 'package:flutter/material.dart';

/// Near-black heading colour used by both detail variants.
const Color _kHeadingColor = AppColors.cardGrey900;

/// Muted subtitle colour for the plain (no status) variant.
const Color _kSubtitleColor = AppColors.cardGrey500;

const _kHeadingStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: _kHeadingColor,
  height: 20 / 14,
);

/// Title and subtitle block for tasks that carry a workflow status.
///
/// Leads with the status pill and "View" link, then the task type and account.
class TaskItemStatusDetails extends StatelessWidget {
  /// Creates a [TaskItemStatusDetails] block.
  const TaskItemStatusDetails({
    required this.status,
    required this.type,
    required this.subtitle,
    required this.onViewTap,
    super.key,
  });

  /// Workflow status shown in the pill.
  final String status;

  /// Task type used as the heading.
  final String type;

  /// Account line ("name" or "name • account type").
  final String subtitle;

  /// Called when the "View" link is tapped.
  final VoidCallback onViewTap;

  static const _subtitleStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 15 / 10,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // Chip hard left, "View" hard right — matching the service-request card.
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: TaskWorkflowChip(status: status)),
            TaskItemViewAction(onTap: onViewTap),
          ],
        ),
        const SizedBox(height: 4),
        Text(type, style: _kHeadingStyle),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: _subtitleStyle.copyWith(color: context.appColors.textSecondary),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

/// Title and subtitle block for tasks without a workflow status.
///
/// Puts the account name and "View" link on one line above the type subtitle.
class TaskItemPlainDetails extends StatelessWidget {
  /// Creates a [TaskItemPlainDetails] block.
  const TaskItemPlainDetails({
    required this.title,
    required this.subtitle,
    required this.onViewTap,
    super.key,
  });

  /// Account display name used as the heading.
  final String title;

  /// Secondary line ("type • account number").
  final String subtitle;

  /// Called when the "View" link is tapped.
  final VoidCallback onViewTap;

  static const _subtitleStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: _kSubtitleColor,
    height: 16 / 12,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(title, style: _kHeadingStyle)),
            TaskItemViewAction(onTap: onViewTap),
          ],
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: _subtitleStyle),
        const SizedBox(height: 4),
      ],
    );
  }
}
