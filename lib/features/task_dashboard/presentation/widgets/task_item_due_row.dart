import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Muted gray used for non-overdue due text; no token equivalent exists.
const Color _kDueTextColor = AppColors.cardGrey600;

/// Computes the localised relative due-date label for [dueDate] (e.g.
/// "Due today", "Due 2 days ago", "Due in 3 days"), or `null` when there is
/// no due date to describe.
///
/// A due date is a pure calendar day, so both it and "today" are truncated to
/// midnight before the day-count difference is taken — a due date with a
/// stray time-of-day must never read as "today" one moment and "tomorrow" the
/// next depending on wall-clock time.
String? taskDueLabel(BuildContext context, DateTime? dueDate) {
  if (dueDate == null) return null;
  final l10n = context.l10n;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
  final diff = dueDay.difference(today).inDays;

  if (diff == 0) return l10n.taskDueToday;
  if (diff < 0) {
    final days = -diff;
    return days == 1 ? l10n.taskDueDaysAgoSingular : l10n.taskDueDaysAgo(days);
  }
  return diff == 1 ? l10n.taskDueInDaySingular : l10n.taskDueInDays(diff);
}

/// Metadata row showing the task's due label with a clock or calendar icon.
///
/// Overdue tasks render in the error colour with heavier weight.
class TaskItemDueRow extends StatelessWidget {
  /// Creates a [TaskItemDueRow] for [label].
  const TaskItemDueRow({
    required this.label,
    required this.isOverdue,
    required this.useCalendarIcon,
    super.key,
  });

  /// Human-readable due text (e.g. "Due today").
  final String label;

  /// Whether the task is past due, which switches to the error styling.
  final bool isOverdue;

  /// Calendar glyph for date-based categories, clock glyph otherwise.
  final bool useCalendarIcon;

  static const _style = TextStyle(fontFamily: 'Inter', fontSize: 12, height: 16 / 12);

  @override
  Widget build(BuildContext context) {
    final color = isOverdue ? context.appColors.statusErrorDefault : _kDueTextColor;

    return Row(
      children: [
        Iconify(
          useCalendarIcon ? Mdi.calendar_outline : Mdi.clock_outline,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: _style.copyWith(
            color: color,
            fontWeight: isOverdue ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
