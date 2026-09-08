import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/features/task_dashboard/presentation/providers/task_dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Horizontally scrollable filter chips for the Task Dashboard.
///
/// Tapping a chip updates [taskFilterProvider] to show All / Overdue /
/// Today / Upcoming / Closed tasks. The active chip is filled; inactive chips
/// are outlined with a white background.
class TaskFilterChipsRow extends ConsumerWidget {
  /// Creates a [TaskFilterChipsRow].
  const TaskFilterChipsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final activeFilter = ref.watch(taskFilterProvider);

    final chips = [
      (TaskFilter.all, l10n.taskDashboardFilterAll),
      (TaskFilter.overdue, l10n.taskDashboardFilterOverdue),
      (TaskFilter.today, l10n.taskDashboardFilterToday),
      (TaskFilter.upcoming, l10n.taskDashboardFilterUpcoming),
      (TaskFilter.closed, l10n.taskDashboardFilterClosed),
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: chips.length,
        itemBuilder: (_, i) {
          final (filter, label) = chips[i];
          final isActive = activeFilter == filter;

          // A chip flip is the state change the reader should barely
          // register, so fill and label cross-fade on one [AppMotion.quick]
          // token — the same treatment the shared pill tab bar uses. Both are
          // paint-only: the padding is fixed, so nothing relayouts.
          final duration = AppMotion.duration(context, AppMotion.quick);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ref.read(taskFilterProvider.notifier).filter = filter,
            child: AnimatedContainer(
              duration: duration,
              curve: AppMotion.enter,
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
              decoration: BoxDecoration(
                color: isActive ? colors.bgBrandNavyBlue : colors.surfaceDefault,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: isActive ? colors.bgBrandNavyBlue : colors.borderDefault,
                ),
                boxShadow: isActive
                    ? const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: AnimatedDefaultTextStyle(
                duration: duration,
                curve: AppMotion.enter,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 20 / 12,
                  color: isActive ? colors.textOnAccent : colors.textSecondary,
                ),
                child: Text(label),
              ),
            ),
          );
        },
      ),
    );
  }
}
