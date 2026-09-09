import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Horizontally scrollable row of filter chips for the notification list.
///
/// Chips: All Notifications | Unread.
/// The active chip renders with the primary brand colour; inactive chips
/// use the subtle border / surface colours from the design system.
class NotificationFilterChipsRow extends ConsumerWidget {
  /// Creates a [NotificationFilterChipsRow].
  const NotificationFilterChipsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(notificationsFilterProvider);
    final notifier = ref.read(notificationsFilterProvider.notifier);
    final colors = context.appColors;

    Widget chip(String label, NotificationFilter filter) {
      final active = current == filter;
      return GestureDetector(
        onTap: () => notifier.setFilter(filter),
        // A chip's fill and border cross over on selection rather than
        // cutting; [AppMotion.quick] is the token for a state flip the reader
        // should barely register.
        child: AnimatedContainer(
          duration: AppMotion.duration(context, AppMotion.quick),
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
          decoration: BoxDecoration(
            color: active ? colors.bgBrandNavyBlue : colors.surfaceDefault,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: active ? colors.bgBrandNavyBlue : colors.borderDefault),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: active ? colors.textOnAccent : colors.textSecondary,
            ),
          ),
        ),
      );
    }

    // The scroll view shrink-wraps to the chips' width, so without the
    // [Align] the parent column centres the whole row on wide screens.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            chip(l10n.notificationsFilterAll, NotificationFilter.all),
            const SizedBox(width: 8),
            chip(l10n.notificationsFilterUnread, NotificationFilter.unread),
          ],
        ),
      ),
    );
  }
}
