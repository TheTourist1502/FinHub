import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Header notification bell icon, shown in the home shell's header bar for
/// the advisor role only — leadership's unread count is not meaningful since
/// notifications are not scoped to a selected advisor.
///
/// Watches [notificationCountProvider] and shows a small red dot only while
/// `unread > 0`. Tap navigation to `AppRoutes.notifications` stays with the
/// caller, since it may want to wrap this differently (plain tap vs. an
/// inked, padded tap target).
class NotificationBellIcon extends ConsumerWidget {
  /// Creates a [NotificationBellIcon].
  const NotificationBellIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final unread = ref.watch(notificationCountProvider).value?.unread ?? 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Iconify(Mdi.bell_outline, color: cs.onSurface),
        if (unread > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colors.statusErrorDefault,
                shape: BoxShape.circle,
                border: Border.all(color: colors.surfaceDefault, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}
