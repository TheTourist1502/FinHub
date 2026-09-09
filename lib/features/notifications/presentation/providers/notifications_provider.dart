import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/notifications/data/notifications_mock_repository.dart';
import 'package:finhub/features/notifications/domain/models/notification_count.dart';
import 'package:finhub/features/notifications/domain/models/notification_item.dart';
import 'package:finhub/features/notifications/domain/notifications_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Active filter applied to the notification list.
enum NotificationFilter {
  /// Show all notifications.
  all,

  /// Show only unread notifications.
  unread,
}

/// The language used to resolve [NotificationBody.content] and
/// [NotificationItem.title].
///
/// This build's ARB files carry only `en` this stage (Spanish and Hindi are
/// paused — see `CHANGELOG.md`), so this is fixed rather than sourced from a
/// locale provider. Revisit once translation resumes.
const String notificationsLang = 'en';

/// Provides the concrete [INotificationsRepository] implementation.
///
/// Override in tests with an in-memory fake.
final notificationsRepositoryProvider = Provider<INotificationsRepository>(
  (ref) => NotificationsMockRepository(ref.watch(mockDataSourceProvider)),
);

/// The advisor's total/unread/read notification counts, driving the header
/// bell's red dot ([NotificationBellIcon]).
///
/// Non-autoDispose: the header bell is visible everywhere in the
/// authenticated app, so this must survive navigating away from any single
/// screen. Fetched once on first watch and explicitly invalidated afterwards
/// by [NotificationsNotifier] after a mutation that changes the unread count.
final notificationCountProvider = FutureProvider<NotificationCount>((ref) {
  return ref.watch(notificationsRepositoryProvider).getNotificationCount();
});

/// Manages the notification list state, including loading and read/delete mutations.
///
/// Non-autoDispose so changes survive navigation away from and back to the
/// Notifications screen within the same app session.
final notificationsProvider = AsyncNotifierProvider<NotificationsNotifier, List<NotificationItem>>(
  NotificationsNotifier.new,
);

/// [AsyncNotifier] that drives the Notifications screen.
class NotificationsNotifier extends AsyncNotifier<List<NotificationItem>> {
  @override
  Future<List<NotificationItem>> build() => ref.watch(notificationsRepositoryProvider).getNotifications();

  /// Re-fetches the notification list (pull-to-refresh).
  ///
  /// Keeps the existing list visible while the request is in flight, then
  /// replaces it on success. Leaves the current list untouched on failure —
  /// the caller is expected to surface an error to the user.
  Future<void> refresh() async {
    try {
      final notifications = await ref.read(notificationsRepositoryProvider).getNotifications();
      state = AsyncData(notifications);
    } on AppError catch (e, s) {
      AppLogger.e('Notifications refresh failed', e, s);
      rethrow;
    } on Object catch (e, s) {
      AppLogger.e('Notifications refresh unexpected error', e, s);
      rethrow;
    }
  }

  /// Marks every notification as read.
  ///
  /// Optimistically updates local state, then persists the change; reverts on
  /// failure. Returns `true` on success so the caller can decide whether to
  /// surface an error.
  Future<bool> markAllRead() async {
    final current = state.value;
    if (current == null) return false;

    final updated = current.map((n) => n.copyWith(isRead: true)).toList();
    state = AsyncData(updated);

    try {
      await ref.read(notificationsRepositoryProvider).markAllAsRead();
      ref.invalidate(notificationCountProvider);
      return true;
    } on AppError catch (e, s) {
      AppLogger.e('Notifications markAllRead failed', e, s);
      state = AsyncData(current);
      return false;
    } on Object catch (e, s) {
      AppLogger.e('Notifications markAllRead unexpected error', e, s);
      state = AsyncData(current);
      return false;
    }
  }

  /// Marks the notification identified by [id] as read.
  ///
  /// Optimistically updates local state, then persists the change; reverts on
  /// failure.
  Future<void> markRead(String id) async {
    final current = state.value;
    if (current == null) return;
    final index = current.indexWhere((n) => n.id == id);
    if (index == -1 || current[index].isRead) return;

    final updated = List<NotificationItem>.from(current);
    updated[index] = updated[index].copyWith(isRead: true);
    state = AsyncData(updated);

    try {
      await ref.read(notificationsRepositoryProvider).markAsRead(id);
      ref.invalidate(notificationCountProvider);
    } on AppError catch (e, s) {
      AppLogger.e('Notifications markRead failed for id=$id', e, s);
      state = AsyncData(current);
    } on Object catch (e, s) {
      AppLogger.e('Notifications markRead unexpected error for id=$id', e, s);
      state = AsyncData(current);
    }
  }

  /// Deletes every notification.
  ///
  /// Returns `true` on success. On failure, local state is left unchanged and
  /// the caller is expected to surface an error to the user.
  Future<bool> clearAll() async {
    final current = state.value;
    if (current == null) return false;

    try {
      await ref.read(notificationsRepositoryProvider).deleteAllNotifications();
      state = const AsyncData([]);
      ref.invalidate(notificationCountProvider);
      return true;
    } on AppError catch (e, s) {
      AppLogger.e('Notifications clearAll failed', e, s);
      return false;
    } on Object catch (e, s) {
      AppLogger.e('Notifications clearAll unexpected error', e, s);
      return false;
    }
  }
}

/// Active category filter for the notification list.
final notificationsFilterProvider = NotifierProvider<NotificationsFilterNotifier, NotificationFilter>(
  NotificationsFilterNotifier.new,
);

/// Holds the active [NotificationFilter].
class NotificationsFilterNotifier extends Notifier<NotificationFilter> {
  @override
  NotificationFilter build() => NotificationFilter.all;

  /// Updates the active filter.
  // ignore: use_setters_to_change_properties // Notifier.state cannot be exposed as a Dart property setter.
  void setFilter(NotificationFilter filter) => state = filter;
}

/// Live text search query for the notification list.
final notificationsSearchProvider = NotifierProvider<NotificationsSearchNotifier, String>(
  NotificationsSearchNotifier.new,
);

/// Holds the current notification search query.
class NotificationsSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  /// Updates the search query.
  // ignore: use_setters_to_change_properties // Notifier.state cannot be exposed as a Dart property setter.
  void setQuery(String query) => state = query;
}

/// Derived notification list filtered by [notificationsFilterProvider]
/// and [notificationsSearchProvider], wrapped in [AsyncValue] so the screen
/// can propagate the loading and error states.
final Provider<AsyncValue<List<NotificationItem>>> filteredNotificationsProvider =
    Provider.autoDispose<AsyncValue<List<NotificationItem>>>((ref) {
      final async = ref.watch(notificationsProvider);
      final filter = ref.watch(notificationsFilterProvider);
      final query = ref.watch(notificationsSearchProvider).trim().toLowerCase();

      return async.whenData((all) {
        var result = switch (filter) {
          NotificationFilter.all => List<NotificationItem>.from(all),
          NotificationFilter.unread => all.where((n) => !n.isRead).toList(),
        };

        if (query.isNotEmpty) {
          result = result
              .where(
                (n) =>
                    n.titleFor(notificationsLang).toLowerCase().contains(query) ||
                    n.body.contentFor(notificationsLang).toLowerCase().contains(query),
              )
              .toList();
        }

        return result;
      });
    });
