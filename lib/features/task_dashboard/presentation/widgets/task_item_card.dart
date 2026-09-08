import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_item_row_content.dart';
import 'package:flutter/material.dart';

export 'package:finhub/features/task_dashboard/presentation/widgets/task_item_open_detail.dart';
export 'package:finhub/features/task_dashboard/presentation/widgets/task_item_section_label.dart';

/// Card border shared by the standalone card and grouped rows.
const Color _kBorderColor = AppColors.cardGrey100;

const _kCornerRadius = Radius.circular(16);

/// A single task rendered as its own rounded card with a shadow.
///
/// Used for overdue, today, open and closed tasks, where each card is
/// visually independent.
class TaskStandaloneCard extends StatelessWidget {
  /// Creates a [TaskStandaloneCard] for [task].
  const TaskStandaloneCard({required this.task, super.key});

  /// The task to display.
  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorderColor),
        boxShadow: [
          BoxShadow(color: colors.cardShadow, blurRadius: 1, offset: const Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.all(17),
      child: TaskItemRowContent(task: task, showDivider: false),
    );
  }
}

/// One row of a grouped card section (e.g. upcoming), buildable on its own so
/// a `SliverList` can build rows lazily instead of a whole group up front.
///
/// [isFirst] and [isLast] round the outer corners and drop the shared edges so
/// adjacent rows read as one continuous card.
class TaskGroupedRow extends StatelessWidget {
  /// Creates a [TaskGroupedRow] for [task].
  const TaskGroupedRow({
    required this.task,
    required this.isFirst,
    required this.isLast,
    super.key,
  });

  /// The task to display.
  final TaskItem task;

  /// Whether this is the first row in its group (top corners rounded).
  final bool isFirst;

  /// Whether this is the last row in its group (bottom corners rounded).
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? _kCornerRadius : Radius.zero,
          topRight: isFirst ? _kCornerRadius : Radius.zero,
          bottomLeft: isLast ? _kCornerRadius : Radius.zero,
          bottomRight: isLast ? _kCornerRadius : Radius.zero,
        ),
        border: Border(
          left: const BorderSide(color: _kBorderColor),
          right: const BorderSide(color: _kBorderColor),
          top: isFirst ? const BorderSide(color: _kBorderColor) : BorderSide.none,
          bottom: isLast ? const BorderSide(color: _kBorderColor) : BorderSide.none,
        ),
        boxShadow: [
          BoxShadow(color: colors.cardShadow, blurRadius: 2, offset: const Offset(0, 1)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: TaskItemRowContent(
        task: task,
        showDivider: !isLast,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
      ),
    );
  }
}
