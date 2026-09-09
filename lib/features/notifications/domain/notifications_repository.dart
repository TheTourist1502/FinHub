import 'package:finhub/features/notifications/domain/models/notification_count.dart';
import 'package:finhub/features/notifications/domain/models/notification_item.dart';

/// Abstract contract for fetching and managing the advisor's notification list.
///
/// The concrete implementation ([NotificationsMockRepository]) is backed by
/// `assets/mock-data/notifications/` — this build has no backend.
abstract interface class INotificationsRepository {
  /// Returns the authenticated advisor's notification list.
  Future<List<NotificationItem>> getNotifications();

  /// Deletes every notification belonging to the authenticated advisor.
  Future<void> deleteAllNotifications();

  /// Marks the notification identified by [id] as read.
  Future<void> markAsRead(String id);

  /// Marks every notification as read for the authenticated advisor.
  Future<void> markAllAsRead();

  /// Returns the authenticated advisor's total/unread/read notification counts.
  Future<NotificationCount> getNotificationCount();
}
