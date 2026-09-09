import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/notifications/models/notification_category.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/notifications/domain/models/notification_count.dart';
import 'package:finhub/features/notifications/domain/models/notification_item.dart';
import 'package:finhub/features/notifications/domain/notifications_repository.dart';
import 'package:flutter/foundation.dart';

/// [INotificationsRepository] backed by `assets/mock-data/notifications/list.json`.
///
/// The fixture carries a single `default` list — notifications are not
/// advisor-scoped in this build, unlike most other mock fixtures, so no
/// [DataScope] is threaded through here. Read state and clears are held via
/// [MockDataSource.readEditable]/[saveEditable] for the life of the session
/// (the same mechanism the personalize feature uses), so the unread badge
/// responds to what the user does. `notifications/count.json` mirrors the
/// `GET /v1/notifications/count` contract but is intentionally unread here —
/// [getNotificationCount] derives the same numbers live from the list so a
/// mutation is reflected immediately without invalidating a second fixture.
class NotificationsMockRepository implements INotificationsRepository {
  /// Creates the repository over [_source].
  const NotificationsMockRepository(this._source);

  final MockDataSource _source;

  /// The fixture backing the notification list.
  static const _path = 'notifications/list.json';

  /// Reads the current rows, including any in-session read/delete edits.
  Future<List<Map<String, dynamic>>> _readRows() async {
    final envelope = await _source.readEditable(_path);
    final rows = envelope['data'];
    return rows is List ? rows.cast<Map<String, dynamic>>() : const [];
  }

  /// Persists [rows] as the session's edit of the fixture.
  void _writeRows(List<Map<String, dynamic>> rows) => _source.saveEditable(_path, {'data': rows});

  @override
  Future<List<NotificationItem>> getNotifications() async {
    final rows = await _readRows();
    final items = <NotificationItem>[];
    for (final raw in rows) {
      try {
        final item = NotificationItem.fromJson(raw);
        if (_isForOtherPlatform(item)) continue;
        items.add(item);
      } on Object catch (e, s) {
        AppLogger.e('Skipping malformed notification: $raw', e, s);
      }
    }
    return items;
  }

  /// System notifications may carry a platform-specific link; one addressed to
  /// the other platform is not shown here.
  bool _isForOtherPlatform(NotificationItem item) {
    if (item.category != NotificationCategory.system) return false;
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => item.body.androidUrl?.isNotEmpty ?? false,
      TargetPlatform.android => item.body.iosUrl?.isNotEmpty ?? false,
      _ => false,
    };
  }

  @override
  Future<void> deleteAllNotifications() async => _writeRows(const []);

  @override
  Future<void> markAsRead(String id) async {
    final rows = await _readRows();
    _writeRows([
      for (final row in rows)
        if (row['id'] == id) {...row, 'isRead': true} else row,
    ]);
  }

  @override
  Future<void> markAllAsRead() async {
    final rows = await _readRows();
    _writeRows([
      for (final row in rows) {...row, 'isRead': true},
    ]);
  }

  @override
  Future<NotificationCount> getNotificationCount() async {
    final rows = await _readRows();
    final read = rows.where((row) => row['isRead'] == true).length;
    return NotificationCount(total: rows.length, unread: rows.length - read, read: read);
  }
}
