import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Small uppercase heading that opens a sub-section of the task detail sheet.
///
/// Callers pass already-localised text; this widget only uppercases and styles it.
class TaskDetailSectionLabel extends StatelessWidget {
  /// Creates a [TaskDetailSectionLabel] showing [text].
  const TaskDetailSectionLabel({required this.text, super.key});

  /// Localised heading text, uppercased on render.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.bodySmall.copyWith(
          color: context.appColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
