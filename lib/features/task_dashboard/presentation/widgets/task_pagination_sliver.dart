import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/task_dashboard/presentation/providers/task_dashboard_provider.dart';
import 'package:finhub/shared/widgets/feedback/pagination_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom-of-list sliver showing the closed-task load-more spinner, the
/// pagination error with retry, or nothing.
///
/// Watches the pagination flags itself so a spinner appearing never rebuilds
/// the task rows above it.
class TaskPaginationSliver extends ConsumerWidget {
  /// Creates a [TaskPaginationSliver].
  const TaskPaginationSliver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(taskDashboardProvider.select((s) => s.value));

    return SliverToBoxAdapter(
      child: PaginationFooter(
        isLoadingMore: dashboard?.isLoadingMoreClosed ?? false,
        hasError: dashboard?.closedPaginationError != null,
        errorLabel: context.l10n.taskDashboardPaginationError,
        // Only an explicit tap retries a failed page — the scroll listener
        // deliberately stops calling loadMoreClosedTasks() after a failure.
        onRetry: () => ref.read(taskDashboardProvider.notifier).loadMoreClosedTasks(isRetry: true),
      ),
    );
  }
}
