import 'dart:async';

import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/relative_time_formatter.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:finhub/features/task_dashboard/presentation/providers/task_dashboard_provider.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_dashboard_shimmer.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_filter_chips_row.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_item_card.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_pagination_sliver.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_search_row.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/widgets/feedback/error_view.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:finhub/shared/widgets/layout/detail_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Full-screen Task Dashboard pushed outside the bottom-nav shell.
///
/// Displays a search bar, filter chips (All / Overdue / Today / Upcoming),
/// and a grouped, scrollable task list. Tapping "View" on any row opens the
/// task detail sheet ([openTaskDetail]). If [initialTaskId] is set (deep
/// link from a task notification), the matching task's detail sheet is
/// opened automatically once the task list loads.
class TaskDashboardScreen extends ConsumerStatefulWidget {
  /// Creates a [TaskDashboardScreen].
  ///
  /// [initialTaskId], when present, opens the detail sheet for the matching
  /// task as soon as the task list resolves; if no task matches, nothing
  /// happens.
  const TaskDashboardScreen({super.key, this.initialTaskId});

  /// Task id to auto-open the detail sheet for, or `null` for none.
  final String? initialTaskId;

  @override
  ConsumerState<TaskDashboardScreen> createState() => _TaskDashboardScreenState();
}

class _TaskDashboardScreenState extends ConsumerState<TaskDashboardScreen> {
  bool _initialSheetHandled = false;

  @override
  void initState() {
    super.initState();
    _initialSheetHandled = widget.initialTaskId == null;
  }

  @override
  void didUpdateWidget(TaskDashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // `go()` reuses this screen's existing page/State when it's already the
    // top of the stack (e.g. tapping the same task's notification a second
    // time while already on this screen) instead of rebuilding from scratch,
    // so a fresh `initialTaskId` arrives here rather than via `initState`.
    // Re-arm the guard whenever it changes to a new, non-null id so the
    // sheet still opens.
    if (widget.initialTaskId != oldWidget.initialTaskId && widget.initialTaskId != null) {
      _initialSheetHandled = false;
    }
  }

  /// Opens the detail sheet for [widget.initialTaskId] once the task list
  /// has resolved, then clears the `taskId` query param so back-nav /
  /// rebuilds don't reopen it. No-ops (but still marks handled) if no task
  /// matches the id.
  void _maybeShowInitialTaskDetail(List<TaskItem> tasks) {
    if (_initialSheetHandled || widget.initialTaskId == null) return;
    _initialSheetHandled = true;

    final task = tasks.where((t) => t.taskId == widget.initialTaskId).firstOrNull;
    if (task == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await openTaskDetail(context, task);
      if (mounted) context.go(AppRoutes.taskDashboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    ref.watch(filteredTasksProvider).whenData(_maybeShowInitialTaskDetail);

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: DetailPageBar(
        label: l10n.taskDashboardTitle,
        onPrevious: () => context.canPop() ? context.pop() : context.go(AppRoutes.home),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // ── Search bar ────────────────────────────────────────────────
            TaskSearchRow(),
            SizedBox(height: 16),

            // ── Filter chips ──────────────────────────────────────────────
            TaskFilterChipsRow(),
            SizedBox(height: 12),

            // ── Task list ─────────────────────────────────────────────────
            Expanded(child: _TaskList()),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main task list
// ---------------------------------------------------------------------------

class _TaskList extends ConsumerWidget {
  const _TaskList();

  /// Requests the next closed-task page once the user has scrolled 80% of the
  /// way down.
  ///
  /// Skips while [ScrollMetrics.maxScrollExtent] is zero — a list that fits on
  /// screen sits at `pixels == maxScrollExtent == 0`, which would otherwise
  /// read as "scrolled to the end" on the very first frame.
  ///
  /// Read off the notification rather than a [ScrollController]: the switcher
  /// below keeps the outgoing list mounted through the crossfade, and with
  /// `skipLoadingOnRefresh: false` a refresh that resolves inside
  /// [AppMotion.base] would briefly leave two scroll views sharing one
  /// controller.
  bool _onScrollNotification(WidgetRef ref, ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.maxScrollExtent > 0 && metrics.pixels >= metrics.maxScrollExtent * 0.8) {
      // Fire-and-forget: loadMoreClosedTasks() guards against duplicate
      // in-flight calls, exhausted pages, and repeat-after-failure.
      unawaited(ref.read(taskDashboardProvider.notifier).loadMoreClosedTasks());
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final filtered = ref.watch(filteredTasksProvider);
    final activeFilter = ref.watch(taskFilterProvider);
    final sortActive = ref.watch(taskSortDescendingProvider);
    final searchQuery = ref.watch(taskSearchQueryProvider);
    final closedTotalCount = ref.watch(taskDashboardProvider.select((s) => s.value?.closedTotalCount ?? 0));

    return RefreshIndicator(
      onRefresh: () => ref.read(taskDashboardProvider.notifier).refresh(),
      // Crossfades the skeleton out as the list arrives instead of cutting to
      // it. The three branches are distinct widget types, so the switcher
      // detects the change without explicit keys.
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) => _onScrollNotification(ref, notification),
        child: AnimatedSwitcher(
          duration: AppMotion.duration(context, AppMotion.base),
          child: filtered.when(
            skipLoadingOnRefresh: false,
            loading: () => const TaskDashboardListShimmer(),
            error: (e, _) => _ScrollableFiller(
              child: Center(
                child: ErrorView(error: e is AppError ? e : const UnknownError()),
              ),
            ),
            data: (tasks) {
              if (tasks.isEmpty) {
                return _ScrollableFiller(
                  child: NoRecordWidget(
                    widthFactor: 0.45,
                    message: searchQuery.trim().isNotEmpty ? l10n.taskDashboardEmptySearch : l10n.taskDashboardNoTasks,
                  ),
                );
              }

              // On the Closed filter the list only holds the pages loaded so far,
              // so `tasks.length` would report "50" against a 350-task backlog.
              // The server's total is the honest number — but only without a
              // search, which the closed endpoint can't apply, leaving the
              // in-memory match count the only meaningful one.
              final headingCount = activeFilter == TaskFilter.closed && searchQuery.trim().isEmpty
                  ? closedTotalCount
                  : tasks.length;
              final headingText = _headingText(activeFilter, headingCount, l10n);
              final groups = _buildGroups(tasks, activeFilter, sortActive);

              // Stagger slots run continuously across sections, so the first
              // screenful arrives as one group instead of restarting the stagger
              // at every header. Each section spends one slot on its own label
              // plus one per row. [SettleIn] caps the delay itself past roughly a
              // screenful, so a long backlog never inherits a growing wait.
              final slotStarts = <int>[];
              var nextSlot = 0;
              for (final group in groups) {
                slotStarts.add(nextSlot);
                nextSlot += group.tasks.length + 1;
              }

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverPadding(padding: EdgeInsets.only(top: 4)),

                  // ── Heading row: count label + live "last updated" timer ────
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              headingText.toUpperCase(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.cardMeta.copyWith(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: _TaskLastUpdatedLabel(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Grouped sections, each lazily built via its own sliver ──
                  // A header and its rows settle in one at a time as the reader
                  // reaches them — the same entrance the dashboard's
                  // recent-transaction rows use.
                  for (final (g, group) in groups.indexed) ...[
                    SliverToBoxAdapter(
                      child: SettleIn(
                        index: slotStarts[g],
                        revealOnScroll: true,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TaskSectionLabel(
                            label: _sectionLabel(group.category, l10n),
                            category: group.category,
                          ),
                        ),
                      ),
                    ),
                    if (group.category == TaskCategory.upcoming)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => SettleIn(
                            index: slotStarts[g] + 1 + index,
                            revealOnScroll: true,
                            child: TaskGroupedRow(
                              task: group.tasks[index],
                              isFirst: index == 0,
                              isLast: index == group.tasks.length - 1,
                            ),
                          ),
                          childCount: group.tasks.length,
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => SettleIn(
                            index: slotStarts[g] + 1 + index,
                            revealOnScroll: true,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: index == group.tasks.length - 1 ? 0 : 8),
                              child: TaskStandaloneCard(task: group.tasks[index]),
                            ),
                          ),
                          childCount: group.tasks.length,
                        ),
                      ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
                  ],

                  // ── Closed-task pagination spinner / retry ──────────────────
                  // Only the closed group paginates, so the footer is meaningless
                  // on a filter that hides it.
                  if (activeFilter == TaskFilter.all || activeFilter == TaskFilter.closed) const TaskPaginationSliver(),

                  const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _headingText(TaskFilter filter, int count, AppLocalizations l10n) => switch (filter) {
    TaskFilter.all => l10n.taskDashboardHeadingAll(count),
    TaskFilter.overdue => l10n.taskDashboardHeadingOverdue(count),
    TaskFilter.today => l10n.taskDashboardHeadingToday(count),
    TaskFilter.upcoming => l10n.taskDashboardHeadingUpcoming(count),
    TaskFilter.closed => l10n.taskDashboardHeadingClosed(count),
  };

  String _sectionLabel(TaskCategory category, AppLocalizations l10n) => switch (category) {
    TaskCategory.overdue => l10n.taskDashboardSectionOverdue,
    TaskCategory.today => l10n.taskDashboardSectionToday,
    TaskCategory.upcoming => l10n.taskDashboardSectionUpcoming,
    TaskCategory.open => l10n.taskDashboardSectionOpen,
    TaskCategory.closed => l10n.taskDashboardSectionClosed,
  };

  List<_TaskGroup> _buildGroups(
    List<TaskItem> tasks,
    TaskFilter filter,
    bool descending,
  ) {
    if (filter != TaskFilter.all) {
      return [_TaskGroup(tasks.first.category, tasks)];
    }

    final map = <TaskCategory, List<TaskItem>>{};
    for (final task in tasks) {
      map.putIfAbsent(task.category, () => []).add(task);
    }

    // Chip order, most urgent first — and the same order as
    // [allFilterCategories], which is what decides who reaches this list.
    // A category with no tasks is skipped rather than rendering an empty
    // section header.
    final ordered = [
      for (final category in [TaskCategory.overdue, TaskCategory.today, TaskCategory.upcoming, TaskCategory.closed])
        if (map[category] case final tasks?) _TaskGroup(category, tasks),
    ];

    return descending ? ordered.reversed.toList() : ordered;
  }
}

// ---------------------------------------------------------------------------
// Full-height scrollable wrapper — keeps error/empty states pull-to-refreshable
// ---------------------------------------------------------------------------

/// Wraps [child] in an always-scrollable, full-height list so
/// [RefreshIndicator] can still be triggered when the content (an error or
/// empty state) doesn't fill the viewport on its own.
class _ScrollableFiller extends StatelessWidget {
  const _ScrollableFiller({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: constraints.maxHeight, child: child),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Group data container
// ---------------------------------------------------------------------------

class _TaskGroup {
  const _TaskGroup(this.category, this.tasks);
  final TaskCategory category;
  final List<TaskItem> tasks;
}

// ---------------------------------------------------------------------------
// Live "last updated" label — sits in the heading row, in place of the
// (removed) sort-by-type toggle
// ---------------------------------------------------------------------------

/// Shows how long ago the dashboard's data was fetched, ticking live.
///
/// Watches [taskDashboardTickerProvider] purely to re-render once a second;
/// the elapsed time itself is derived from [taskDashboardLastFetchedAtProvider]
/// each time. Uses a compact format: "a few sec ago", "1 min ago" / "N mins
/// ago", "1hr ago" / "Nhrs ago", "1 day ago" / "N days ago".
class _TaskLastUpdatedLabel extends ConsumerWidget {
  const _TaskLastUpdatedLabel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final lastFetchedAt = ref.watch(taskDashboardLastFetchedAtProvider);
    ref.watch(taskDashboardTickerProvider);

    if (lastFetchedAt == null) return const SizedBox.shrink();

    final elapsed = relativeTimeSince(lastFetchedAt, DateTime.now());
    final text = switch (elapsed.unit) {
      RelativeTimeUnit.justNow => l10n.taskDashboardUpdatedJustNow,
      RelativeTimeUnit.minutes =>
        elapsed.count == 1
            ? l10n.taskDashboardUpdatedMinutesAgoSingular
            : l10n.taskDashboardUpdatedMinutesAgo(elapsed.count),
      RelativeTimeUnit.hours =>
        elapsed.count == 1
            ? l10n.taskDashboardUpdatedHoursAgoSingular
            : l10n.taskDashboardUpdatedHoursAgo(elapsed.count),
      RelativeTimeUnit.days =>
        elapsed.count == 1 ? l10n.taskDashboardUpdatedDaysAgoSingular : l10n.taskDashboardUpdatedDaysAgo(elapsed.count),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Iconify(Mdi.clock_outline, color: colors.textTertiary, size: 12),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.cardMeta.copyWith(color: colors.textTertiary),
        ),
      ],
    );
  }
}
