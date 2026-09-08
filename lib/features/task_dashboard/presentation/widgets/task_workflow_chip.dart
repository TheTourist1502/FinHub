import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Rounded pill showing the workflow stage a task is sitting in.
///
/// Unlike `StatusChip` this one is not colour-coded, does not translate and
/// carries no glyph: it shows the API's own wording on the info palette, so a
/// stage the backend adds tomorrow still renders correctly today. The dense,
/// uppercase treatment is the only one — every call site is a list card or a
/// detail row where the section heading already says what the chip is about.
class TaskWorkflowChip extends StatelessWidget {
  /// Creates a [TaskWorkflowChip] for the raw API [status] text.
  const TaskWorkflowChip({required this.status, super.key});

  /// Raw workflow status text from the API (e.g. "Pending Ops Review").
  final String? status;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final label = (status ?? '').trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: colors.statusInfoBg, borderRadius: BorderRadius.circular(4)),
      child: Text(
        label.isEmpty ? '—' : label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 15 / 10,
          color: colors.statusInfoText,
        ),
      ),
    );
  }
}
