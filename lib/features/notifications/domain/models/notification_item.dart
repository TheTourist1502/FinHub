import 'package:finhub/core/notifications/models/notification_category.dart';
import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// Parses a `{en, es}`-shaped JSON map into a `Map<String, String>`.
Map<String, String> _parseLocalizedMap(dynamic json) => Map<String, String>.from(json as Map? ?? const {});

/// Resolves localised text for [lang], falling back to English, then to
/// whichever translation is available.
String resolveLocalized(Map<String, String> map, String lang) =>
    map[lang] ?? map['en'] ?? (map.values.isEmpty ? '' : map.values.first);

/// Localised message content, title, deep-link target, and illustration for
/// a notification.
@immutable
class NotificationBody {
  /// Creates a [NotificationBody].
  const NotificationBody({
    required this.deeplink,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.androidUrl,
    required this.iosUrl,
    required this.correlationId,
  });

  /// Deserialises from the `body` object of a raw notification JSON map.
  factory NotificationBody.fromJson(Map<String, dynamic> json) => NotificationBody(
    deeplink: json['deeplink'] as String? ?? '',
    title: _parseLocalizedMap(json['title']),
    content: _parseLocalizedMap(json['content']),
    imageUrl: json['imageUrl'] as String? ?? '',
    androidUrl: json['androidUrl'] as String?,
    iosUrl: json['iosUrl'] as String?,
    correlationId: json['correlationId'] as String?,
  );

  /// In-app deep-link URI (e.g. `finhub://service-requests/{id}`), empty when none.
  final String deeplink;

  /// Title text keyed by API language code (`en`, `es`).
  final Map<String, String> title;

  /// Message text keyed by API language code (`en`, `es`).
  final Map<String, String> content;

  /// Optional illustration/image URL associated with the notification, empty when none.
  final String imageUrl;

  /// Store-listing URL to launch externally on Android instead of navigating
  /// in-app, when the backend sends one — `null` if absent.
  final String? androidUrl;

  /// Store-listing URL to launch externally on iOS instead of navigating
  /// in-app, when the backend sends one — `null` if absent.
  final String? iosUrl;

  /// Id of the entity this notification relates to (e.g. a task id, article
  /// id), `null` if the backend didn't send one.
  final String? correlationId;

  /// Returns the title for [lang], falling back to English, then to
  /// whichever translation is available.
  String titleFor(String lang) => resolveLocalized(title, lang);

  /// Returns the message for [lang], falling back to English, then to
  /// whichever translation is available.
  String contentFor(String lang) => resolveLocalized(content, lang);
}

/// Immutable domain model for a single notification list item.
@immutable
class NotificationItem {
  /// Creates a [NotificationItem].
  const NotificationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  /// Deserialises from a raw JSON map (camelCase API fields).
  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    id: json['id'] as String,
    category: NotificationCategory.fromString(json['category'] as String? ?? ''),
    title: _parseLocalizedMap(json['title']),
    body: NotificationBody.fromJson(json['body'] as Map<String, dynamic>? ?? const {}),
    isRead: json['isRead'] as bool? ?? false,
    createdAt: parseOptionalDateTime(json['createdAt']),
  );

  /// Server-assigned unique identifier — used to target a mark-as-read call.
  final String id;

  /// Domain context that drives the icon and badge colour in the UI.
  final NotificationCategory category;

  /// Notification headline text keyed by API language code (`en`, `es`).
  final Map<String, String> title;

  /// Localised message content, title, deep-link target, and illustration.
  final NotificationBody body;

  /// Whether the advisor has already read this notification.
  final bool isRead;

  /// Timestamp the notification was created, `null` if the server omitted
  /// or sent an unparseable `createdAt`.
  final DateTime? createdAt;

  /// Returns the headline for [lang], falling back to English, then to
  /// whichever translation is available.
  String titleFor(String lang) => resolveLocalized(title, lang);

  /// Returns a copy with [isRead] overridden.
  NotificationItem copyWith({bool? isRead}) => NotificationItem(
    id: id,
    category: category,
    title: title,
    body: body,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt,
  );
}
