import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// Typed view over the `data` object of `GET /v1/notifications/count`.
///
/// Response shape: `{"data": {"total": int, "unread": int, "read": int}}` —
/// [fromJson] parses the inner `data` object only; unwrapping the envelope is
/// the caller's ([NotificationsMockRepository]) responsibility, matching how
/// `NotificationItem.fromJson` is used for the list endpoint.
@immutable
class NotificationCount {
  /// Creates a [NotificationCount].
  const NotificationCount({required this.total, required this.unread, required this.read});

  /// Parses the `data` object of `GET /v1/notifications/count`.
  factory NotificationCount.fromJson(Map<String, dynamic> json) {
    return NotificationCount(
      total: parseInt(json['total']),
      unread: parseInt(json['unread']),
      read: parseInt(json['read']),
    );
  }

  /// All-zero counts, used as the value before the first fetch resolves.
  static const zero = NotificationCount(total: 0, unread: 0, read: 0);

  /// Total number of notifications (read + unread).
  final int total;

  /// Number of unread notifications — drives the header bell's red dot.
  final int unread;

  /// Number of read notifications.
  final int read;
}
