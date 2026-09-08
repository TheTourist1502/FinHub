import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Trailing "View" link that opens the task detail sheet.
///
/// Prop-driven: the caller supplies [onTap] so this stays presentation-only.
class TaskItemViewAction extends StatelessWidget {
  /// Creates a [TaskItemViewAction] invoking [onTap] when tapped.
  const TaskItemViewAction({required this.onTap, super.key});

  /// Called when the link is tapped.
  final VoidCallback onTap;

  static const _style = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    height: 26 / 13,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          context.l10n.taskDashboardView,
          style: _style.copyWith(color: colors.interactiveDefault),
        ),
      ),
    );
  }
}
