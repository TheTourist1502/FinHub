import 'package:finhub/core/notifications/models/notification_category.dart';
import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// Immutable domain model for a single quick-action shortcut that can appear
/// on the Home screen dashboard.
@immutable
class QuickActionItem {
  /// Creates a [QuickActionItem].
  const QuickActionItem({
    required this.id,
    required this.label,
    required this.order,
    required this.isEnabled,
    required this.quickActionKey,
  });

  /// Deserialises from a raw JSON map.
  factory QuickActionItem.fromJson(Map<String, dynamic> json) => QuickActionItem(
    id: json['id'] as String,
    label: json['label'] as String,
    order: parseInt(json['order']),
    isEnabled: json['isEnabled'] as bool,
    quickActionKey: json['quickActionKey'] as String,
  );

  /// Server-assigned UUID for this quick-action record.
  final String id;

  /// Human-readable display name shown on the Home screen (e.g. `Client Search`).
  final String label;

  /// Display position in the ordered list (0-based).
  final int order;

  /// Whether this action is currently shown on the Home screen.
  final bool isEnabled;

  /// Stable semantic key used for routing and icon lookup (e.g. `client_search`).
  final String quickActionKey;

  /// Returns a copy with overridden fields.
  QuickActionItem copyWith({bool? isEnabled, int? order}) => QuickActionItem(
    id: id,
    label: label,
    order: order ?? this.order,
    isEnabled: isEnabled ?? this.isEnabled,
    quickActionKey: quickActionKey,
  );

  /// Serialises to a JSON map.
  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'order': order,
    'isEnabled': isEnabled,
    'quickActionKey': quickActionKey,
  };
}

/// Immutable domain model for a single notification-preference toggle.
@immutable
class NotificationItem {
  /// Creates a [NotificationItem].
  const NotificationItem({
    required this.id,
    required this.label,
    required this.actionKey,
    required this.isEnabled,
  });

  /// Deserialises from a raw JSON map.
  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    id: NotificationCategory.fromString(json['id'] as String),
    label: json['label'] as String,
    actionKey: json['actionKey'] as String,
    isEnabled: json['isEnabled'] as bool,
  );

  /// Notification category this record represents (e.g. `SERVICE_REQUEST`).
  final NotificationCategory id;

  /// Human-readable display name (e.g. `Service Requests`).
  final String label;

  /// Stable semantic key used to identify the notification category (e.g. `service_requests`),
  /// distinct from and unaffected by the [id] value space.
  final String actionKey;

  /// Whether the user has opted in to this notification category.
  final bool isEnabled;

  /// Returns a copy with [isEnabled] overridden.
  NotificationItem copyWith({bool? isEnabled}) => NotificationItem(
    id: id,
    label: label,
    actionKey: actionKey,
    isEnabled: isEnabled ?? this.isEnabled,
  );

  /// Serialises to a JSON map.
  Map<String, dynamic> toJson() => {
    'id': id.toApiValue(),
    'label': label,
    'actionKey': actionKey,
    'isEnabled': isEnabled,
  };
}

/// Aggregate personalisation settings for the authenticated advisor.
///
/// Holds the ordered list of quick-action shortcuts and the notification
/// preferences. Both lists are immutable; the provider layer creates
/// new instances when the user mutates state.
@immutable
class PersonalizeData {
  /// Creates a [PersonalizeData].
  const PersonalizeData({required this.quickActions, required this.notifications});

  /// Deserialises from a raw JSON map returned by `GET /v1/profile/personalization`.
  factory PersonalizeData.fromJson(Map<String, dynamic> json) {
    final qaList = (json['quickActions'] as List<dynamic>).cast<Map<String, dynamic>>();
    final nList = (json['notifications'] as List<dynamic>).cast<Map<String, dynamic>>();
    return PersonalizeData(
      quickActions: qaList.map(QuickActionItem.fromJson).toList(),
      notifications: nList.map(NotificationItem.fromJson).toList(),
    );
  }

  /// Ordered list of quick-action items as currently configured by the advisor.
  final List<QuickActionItem> quickActions;

  /// List of notification-preference toggles.
  final List<NotificationItem> notifications;

  /// Returns a copy with overridden fields.
  PersonalizeData copyWith({
    List<QuickActionItem>? quickActions,
    List<NotificationItem>? notifications,
  }) => PersonalizeData(
    quickActions: quickActions ?? this.quickActions,
    notifications: notifications ?? this.notifications,
  );

  /// Serialises to a JSON map for `POST /v1/profile/personalization`.
  Map<String, dynamic> toJson() => {
    'quickActions': quickActions.map((a) => a.toJson()).toList(),
    'notifications': notifications.map((n) => n.toJson()).toList(),
  };
}
