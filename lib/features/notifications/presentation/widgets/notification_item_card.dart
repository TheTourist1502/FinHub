import 'package:finhub/core/notifications/models/notification_category.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/date_display_formatter.dart';
import 'package:finhub/features/notifications/domain/models/notification_item.dart';
import 'package:finhub/shared/animations/pressable.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:intl/intl.dart';

/// A single row in the notification list.
///
/// Layout (left → right):
/// - 48×48 pill icon badge — colour and icon driven by [NotificationCategory].
/// - Title + localised body content (2-line max) + created-at timestamp.
///   Both title and body render Bold while [NotificationItem.isRead] is
///   false, SemiBold/Regular once read.
/// - Unread dot (top-right, only when [NotificationItem.isRead] is false) +
///   chevron arrow (bottom-right).
///
/// Tapping the row invokes [onTap] (used by the screen to mark it read).
/// The row dips under a finger via [Pressable], which listens to raw pointer
/// events rather than entering the gesture arena, so the [InkWell] keeps both
/// its tap callback and its ripple.
/// A hairline divider separates items unless [isLast] is true.
class NotificationItemCard extends StatelessWidget {
  /// Creates a [NotificationItemCard].
  const NotificationItemCard({
    required this.item,
    required this.isLast,
    required this.lang,
    required this.onTap,
    super.key,
  });

  /// The notification to display.
  final NotificationItem item;

  /// Suppresses the bottom divider when true (last item in a section card).
  final bool isLast;

  /// API language code used to resolve [NotificationItem.body] content.
  final String lang;

  /// Invoked when the row is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (bgColor, iconSvg, iconColor) = _badgeStyle(item.category, colors);

    return Column(
      children: [
        Pressable(
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Icon badge ──────────────────────────────────────────────
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Center(
                      child: Iconify(iconSvg, color: iconColor),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ── Content ─────────────────────────────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.titleFor(lang),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.body.contentFor(lang),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: item.isRead ? FontWeight.w400 : FontWeight.w700,
                            color: colors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.createdAt != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            DateFormat('MMM d, yyyy h:mm a').formatLocal(item.createdAt!),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: colors.textTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ── Unread dot + chevron ─────────────────────────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!item.isRead)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: colors.textPrimary,
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const SizedBox(height: 10),
                      const SizedBox(height: 20),
                      Iconify(Mdi.chevron_right, size: 16, color: colors.textSecondary),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: colors.borderDefault,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  /// Returns (bgColor, iconSvg, iconColor) for the given [category].
  (Color, String, Color) _badgeStyle(
    NotificationCategory category,
    AppColorTokens colors,
  ) => switch (category) {
    NotificationCategory.serviceRequest => (
      colors.statusErrorBg,
      Mdi.bell_alert,
      colors.statusErrorDefault,
    ),
    NotificationCategory.task => (
      colors.statusSuccessBg,
      Mdi.clipboard_check,
      colors.statusSuccessDefault,
    ),
    NotificationCategory.marketInsight => (
      colors.statusWarningBg,
      Mdi.trending_up,
      colors.statusWarningDefault,
    ),
    NotificationCategory.system => (
      colors.statusInfoBg,
      Mdi.cog,
      colors.statusInfoDefault,
    ),
  };
}
