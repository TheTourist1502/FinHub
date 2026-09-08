import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_detail_additional_details.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_detail_header.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_detail_summary.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_sheet_close_button.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_sheet_handle.dart';
import 'package:flutter/material.dart';

/// Shows the [TaskDetailBottomSheet] over the current route.
///
/// Call this instead of [showModalBottomSheet] directly to ensure consistent
/// shape, shadow, and drag behaviour.
Future<void> showTaskDetailBottomSheet(BuildContext context, TaskItem task) {
  // Single funnel for every detail view (card tap and deep link alike), so this
  // log captures exactly the payload being rendered. Stripped in release.
  AppLogger.w('Task detail opened → $task');

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => TaskDetailBottomSheet(task: task),
  );
}

/// Modal bottom sheet showing the full detail of a [TaskItem].
///
/// Drag handle plus a scrollable body, with the close button pinned to the
/// bottom regardless of scroll position.
class TaskDetailBottomSheet extends StatelessWidget {
  /// Creates a [TaskDetailBottomSheet] for [task].
  const TaskDetailBottomSheet({required this.task, super.key});

  /// The task whose details are displayed.
  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.appColors.surfaceDefault,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            const TaskSheetHandle(),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TaskDetailHeader(task: task),
                    TaskDetailSummary(task: task),
                    const SizedBox(height: 24),
                    TaskDetailAdditionalDetails(task: task),
                  ],
                ),
              ),
            ),
            const SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: TaskSheetCloseButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
