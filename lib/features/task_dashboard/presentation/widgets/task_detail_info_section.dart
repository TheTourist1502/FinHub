import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Heading over a paragraph of body text, the repeating block of the task
/// detail sheet (description, pending action, workflow progress).
class TaskDetailInfoSection extends StatelessWidget {
  /// Creates a [TaskDetailInfoSection] showing [body] under [heading].
  const TaskDetailInfoSection({required this.heading, required this.body, super.key});

  /// Localised section heading.
  final String heading;

  /// Localised or pre-formatted paragraph text.
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: AppTypography.sectionTitle.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          body,
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textSecondary,
            fontSize: 14,
            height: 1.625,
          ),
        ),
      ],
    );
  }
}
