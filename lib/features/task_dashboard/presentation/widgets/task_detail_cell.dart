import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Stacked label-over-value cell used in the task additional-details grid.
///
/// Atomic and prop-driven; callers size it (typically inside an [Expanded]).
class TaskDetailCell extends StatelessWidget {
  /// Creates a [TaskDetailCell] showing [value] under [label].
  const TaskDetailCell({required this.label, required this.value, super.key});

  /// Localised field name shown above the value.
  final String label;

  /// Pre-formatted value shown below [label].
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.cardMeta.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
