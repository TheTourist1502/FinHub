import 'dart:async';

import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/core/utils/date_sort_utils.dart';
import 'package:finhub/features/task_dashboard/data/task_dashboard_mock_repository.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_dashboard_state.dart';
import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:finhub/features/task_dashboard/domain/task_dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// Filter enum
// ---------------------------------------------------------------------------

/// Active filter chip on the Task Dashboard screen.
enum TaskFilter {
  /// Show the categories listed in [allFilterCategories].
  all,

  /// Show only tasks with [TaskCategory.overdue].
  overdue,

  /// Show only tasks with [TaskCategory.today].
  today,

  /// Show only tasks with [TaskCategory.upcoming].
  upcoming,

  /// Show only tasks with [TaskCategory.closed].
  closed,
}

/// Categories [TaskFilter.all] shows — one per filter chip, in chip order.
///
/// [TaskCategory.open] is the one category left out: it has no chip of its
/// own, and the API only ever uses it for rows that carry no time bucket, so
/// it is not surfaced on the dashboard at all.
const Set<TaskCategory> allFilterCategories = {
  TaskCategory.overdue,
  TaskCategory.today,
  TaskCategory.upcoming,
  TaskCategory.closed,
};

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------

/// Provides the active [ITaskDashboardRepository] implementation.
///
/// Override with a fake in widget/unit tests to avoid loading assets.
final Provider<ITaskDashboardRepository> taskDashboardRepositoryProvider = Provider<ITaskDashboardRepository>(
  (ref) => TaskDashboardMockRepository(ref.watch(mockDataSourceProvider), ref.watch(dataScopeProvider)),
);

// ---------------------------------------------------------------------------
// Raw data provider
// ---------------------------------------------------------------------------

/// Loads all tasks from the repository — unsorted and unfiltered.
///
/// Owns both halves of the dashboard: the whole summary response, and the
/// closed tasks paged in from a separate endpoint as the user scrolls.
// ignore: specify_nonobvious_property_types
final taskDashboardProvider = AsyncNotifierProvider.autoDispose<TaskDashboardNotifier, TaskDashboardState>(
  TaskDashboardNotifier.new,
);

/// Drives the task dashboard: initial load, closed-task pagination, refresh.
///
/// `GET /v1/tasks/summary` returns overdue/today/upcoming/open rows in full,
/// but only a *count* of closed tasks — the rows come from
/// `GET /v1/tasks/closed`, [closedTasksPageSize] at a time. Both requests are
/// issued together on load, and [loadMoreClosedTasks] appends the rest.
///
/// A failed closed page never fails the screen: the summary still renders and
/// the error surfaces in the list footer, because losing the closed half is
/// far less disruptive than replacing the whole dashboard with an error.
class TaskDashboardNotifier extends AsyncNotifier<TaskDashboardState> {
  /// Number of the first closed page. The endpoint's page numbers are
  /// one-based and it rejects `0` outright with a 400.
  static const int _firstClosedPage = 1;

  @override
  Future<TaskDashboardState> build() async {
    // Deferred to a microtask because Riverpod forbids a provider from writing
    // to another provider synchronously while it is still building.
    unawaited(
      Future.microtask(() {
        if (ref.mounted) ref.read(taskDashboardLastFetchedAtProvider.notifier).markFetchStarted();
      }),
    );
    return _loadFirstPage();
  }

  /// Fetches the summary and the first closed page concurrently.
  ///
  /// Both futures are started before the first `await` so the two requests
  /// overlap on the wire. The closed one can't throw — [_fetchClosedPage]
  /// captures its failure — so abandoning it when the summary throws can't
  /// leave an unhandled async error behind.
  Future<TaskDashboardState> _loadFirstPage() async {
    final repository = ref.read(taskDashboardRepositoryProvider);
    final summaryFuture = repository.getTasks();
    final closedFuture = _fetchClosedPage(repository, _firstClosedPage);

    final summary = await summaryFuture;
    final (tasks: closedTasks, error: closedError) = await closedFuture;

    return TaskDashboardState(
      summaryTasks: summary.tasks,
      closedTasks: closedTasks,
      closedTotalCount: summary.closedTotalCount,
      // Stays at 0 when the first page failed, so retrying re-requests that
      // page instead of skipping past it to the second.
      closedPagesLoaded: closedError == null ? 1 : 0,
      closedPageWasShort: closedError == null && closedTasks.length < closedTasksPageSize,
      closedPaginationError: closedError,
    );
  }

  /// Requests closed page [startPage], returning the rows or the error.
  ///
  /// Never throws: pagination failures are state, not exceptions, so both the
  /// initial load and [loadMoreClosedTasks] can keep whatever they already have.
  Future<({List<TaskItem> tasks, AppError? error})> _fetchClosedPage(
    ITaskDashboardRepository repository,
    int startPage,
  ) async {
    try {
      return (tasks: await repository.getClosedTasks(startPage: startPage), error: null);
    } on AppError catch (e, s) {
      AppLogger.e('TaskDashboardNotifier: closed page $startPage failed', e, s);
      return (tasks: const <TaskItem>[], error: e);
    } on Object catch (e, s) {
      AppLogger.e('TaskDashboardNotifier: closed page $startPage unexpected error', e, s);
      return (tasks: const <TaskItem>[], error: const UnknownError());
    }
  }

  /// Fetches the next closed page and appends it to the list.
  ///
  /// Returns early when a request is already running or every closed task has
  /// been loaded, so it is safe to call from a scroll listener on every frame.
  /// After a failure it also returns early unless [isRetry] is set — otherwise
  /// the scroll listener would re-fire the same failing request continuously.
  /// The footer's retry button is the only caller that passes `isRetry: true`.
  Future<void> loadMoreClosedTasks({bool isRetry = false}) async {
    final current = state.value;
    if (current == null || current.isLoadingMoreClosed || !current.hasMoreClosed) return;
    if (current.closedPaginationError != null && !isRetry) return;

    state = AsyncData(current.copyWith(isLoadingMoreClosed: true, clearPaginationError: true));

    final page = await _fetchClosedPage(
      ref.read(taskDashboardRepositoryProvider),
      current.closedPagesLoaded + _firstClosedPage,
    );
    if (!ref.mounted) return;

    if (page.error != null) {
      state = AsyncData(current.copyWith(isLoadingMoreClosed: false, closedPaginationError: page.error));
      return;
    }

    state = AsyncData(
      current.copyWith(
        closedTasks: [...current.closedTasks, ...page.tasks],
        closedPagesLoaded: current.closedPagesLoaded + 1,
        isLoadingMoreClosed: false,
        closedPageWasShort: page.tasks.length < closedTasksPageSize,
        clearPaginationError: true,
      ),
    );
  }

  /// Reloads both endpoints from scratch for pull-to-refresh.
  ///
  /// Rebuilds through [build], so every loaded closed page is dropped and
  /// paging restarts at page 0 — a refresh can never stitch stale pages onto
  /// fresh ones.
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } on Object catch (e, s) {
      // The rebuilt provider already exposes this as AsyncError, and the list
      // renders it. Swallowing it here only keeps RefreshIndicator's future
      // from completing with an error nobody is positioned to handle.
      AppLogger.e('TaskDashboardNotifier.refresh failed', e, s);
    }
  }
}

// ---------------------------------------------------------------------------
// Last-fetched tracking + live ticker
// ---------------------------------------------------------------------------

/// Wall-clock time at which the most recent [taskDashboardProvider] fetch
/// was triggered, or `null` before the first fetch.
final NotifierProvider<TaskDashboardLastFetchedAtNotifier, DateTime?> taskDashboardLastFetchedAtProvider =
    NotifierProvider<TaskDashboardLastFetchedAtNotifier, DateTime?>(TaskDashboardLastFetchedAtNotifier.new);

/// Holds the timestamp of the most recent dashboard fetch.
class TaskDashboardLastFetchedAtNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  /// Records "now" as the moment a dashboard fetch was triggered.
  void markFetchStarted() => state = DateTime.now();
}

/// Emits an incrementing tick once per second while watched.
///
/// Has no data of its own — widgets watch it purely to force a rebuild each
/// second so a "updated X ago" label stays live without re-fetching data.
final StreamProvider<int> taskDashboardTickerProvider = StreamProvider.autoDispose<int>((ref) {
  return Stream<int>.periodic(const Duration(seconds: 1), (tick) => tick);
});

// ---------------------------------------------------------------------------
// UI state providers
// ---------------------------------------------------------------------------

/// Manages the active filter chip.
final NotifierProvider<TaskFilterNotifier, TaskFilter> taskFilterProvider =
    NotifierProvider<TaskFilterNotifier, TaskFilter>(TaskFilterNotifier.new);

/// Holds the currently selected [TaskFilter].
class TaskFilterNotifier extends Notifier<TaskFilter> {
  @override
  TaskFilter build() => TaskFilter.all;

  /// Returns the active filter.
  TaskFilter get filter => state;

  /// Switches to [filter] and rebuilds all dependents.
  set filter(TaskFilter filter) => state = filter;
}

/// Manages the live search query string.
final NotifierProvider<TaskSearchNotifier, String> taskSearchQueryProvider =
    NotifierProvider<TaskSearchNotifier, String>(TaskSearchNotifier.new);

/// Holds the current search query.
class TaskSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  /// Returns the current search query.
  String get query => state;

  /// Updates [query] and rebuilds all dependents.
  set query(String query) => state = query;
}

/// Manages the date sort direction: `false` = ascending, `true` = descending.
final NotifierProvider<TaskSortDescendingNotifier, bool> taskSortDescendingProvider =
    NotifierProvider<TaskSortDescendingNotifier, bool>(
      TaskSortDescendingNotifier.new,
    );

/// Toggles between ascending (`false`) and descending (`true`) date sort.
class TaskSortDescendingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// Flips the sort direction.
  void toggle() => state = !state;
}

// ---------------------------------------------------------------------------
// Derived — filtered + sorted list
// ---------------------------------------------------------------------------

/// Returns the tasks matching the active [taskFilterProvider] and
/// [taskSearchQueryProvider], sorted by [taskSortDescendingProvider].
final Provider<AsyncValue<List<TaskItem>>> filteredTasksProvider = Provider.autoDispose<AsyncValue<List<TaskItem>>>((
  ref,
) {
  final async = ref.watch(taskDashboardProvider);
  final filter = ref.watch(taskFilterProvider);
  final query = ref.watch(taskSearchQueryProvider).trim().toLowerCase();
  final descending = ref.watch(taskSortDescendingProvider);

  return async.whenData((dashboard) {
    // Summary rows and every closed page loaded so far, flattened. Search and
    // sort therefore only ever see the closed tasks already paged in — the
    // closed endpoint takes no search parameter, so there is nothing to
    // delegate to the server.
    var result = dashboard.allTasks;

    // Category filter. `all` is a set rather than a pass-through: it shows
    // every bucket that has a chip, which excludes `open` — see
    // [allFilterCategories].
    final allowedCategories = switch (filter) {
      TaskFilter.all => allFilterCategories,
      TaskFilter.overdue => {TaskCategory.overdue},
      TaskFilter.today => {TaskCategory.today},
      TaskFilter.upcoming => {TaskCategory.upcoming},
      TaskFilter.closed => {TaskCategory.closed},
    };
    result = result.where((t) => allowedCategories.contains(t.category)).toList();

    // Text search — matches against every field of the task, including the
    // ones only surfaced in the detail bottom sheet (description, action
    // pending, workflow status, account number, created/closed dates).
    if (query.isNotEmpty) {
      result = result.where((t) => t.matchesSearch(query)).toList();
    }

    // Sort by due date — ascending (earliest first) or descending (latest
    // first). Tasks with no due date sort last in both directions, so "no due
    // date" never reads as the most urgent or the furthest out.
    return ([...result]..sort((a, b) => compareDates(a.dueDate, b.dueDate, descending: descending)));
  });
});
