/// Domain classification of a notification, driving the list icon/badge
/// colour, push-tap routing, and — for `/v1/profile/personalization` — which
/// notification-preference toggle a row represents.
///
/// Lives in `core/` (not a feature) because it's shared across the
/// notifications feature, the personalize feature, and `core/notifications`
/// push-routing infrastructure.
enum NotificationCategory {
  /// A service request workflow event.
  serviceRequest,

  /// A task assignment or completion event.
  task,

  /// A market insight article or alert.
  marketInsight,

  /// A system-level notice (e.g. scheduled maintenance).
  system;

  /// Parses a raw API category/id string into a [NotificationCategory].
  ///
  /// Accepts both `MARKET_INSIGHTS` (the `/v1/notifications` push
  /// `category` spelling) and `MARKET_INSIGHT` (the
  /// `/v1/profile/personalization` `id` spelling) for [marketInsight].
  /// Falls back to [system] for any unrecognised value.
  factory NotificationCategory.fromString(String value) => switch (value) {
    'SERVICE_REQUEST' => NotificationCategory.serviceRequest,
    'TASK' => NotificationCategory.task,
    'MARKET_INSIGHT' || 'MARKET_INSIGHTS' => NotificationCategory.marketInsight,
    _ => NotificationCategory.system,
  };

  /// Serialises back to the API string used by
  /// `PATCH /v1/profile/personalization`'s `notifications[].id`.
  String toApiValue() => switch (this) {
    NotificationCategory.serviceRequest => 'SERVICE_REQUEST',
    NotificationCategory.task => 'TASK',
    NotificationCategory.marketInsight => 'MARKET_INSIGHT',
    NotificationCategory.system => 'SYSTEM',
  };
}
