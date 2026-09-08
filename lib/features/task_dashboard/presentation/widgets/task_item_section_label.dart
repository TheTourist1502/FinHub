import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:flutter/material.dart';

/// Uppercase label rendered above each task group.
///
/// Red for overdue, muted gray for every other category.
class TaskSectionLabel extends StatelessWidget {
  /// Creates a [TaskSectionLabel] for [label] in [category].
  const TaskSectionLabel({required this.label, required this.category, super.key});

  /// Uppercase text (e.g. "OVERDUE", "TODAY", "UPCOMING").
  final String label;

  /// Category that drives the label colour.
  final TaskCategory category;

  static const _style = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
    height: 16 / 12,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = category == TaskCategory.overdue ? colors.statusErrorDefault : colors.textTertiary;

    return Text(label, style: _style.copyWith(color: color));
  }
}
