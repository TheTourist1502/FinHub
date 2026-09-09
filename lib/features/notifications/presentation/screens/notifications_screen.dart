import 'dart:async';

import 'package:finhub/core/feedback/snackbar_service.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:finhub/features/notifications/presentation/widgets/notification_filter_chips_row.dart';
import 'package:finhub/features/notifications/presentation/widgets/notification_item_card.dart';
import 'package:finhub/features/notifications/presentation/widgets/notifications_list_shimmer.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

/// Full-screen Notifications route (`/notifications`).
///
/// Lists the advisor's notifications with text search and All/Unread filter
/// chips. The AppBar overflow menu exposes Mark All as Read and Clear All
/// actions.
///
/// Tapping a row marks it read but does not yet navigate to the target
/// screen — that requires a `NotificationRouter` mapping category/deeplink to
/// a route, which is a later stage's work (see
/// `.claude/docs/folder-structure.md`'s `core/notifications/` entry).
class NotificationsScreen extends ConsumerWidget {
  /// Creates a [NotificationsScreen].
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: colors.surfaceDefault,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Iconify(Mdi.arrow_left, color: colors.textPrimary, size: 22),
          onPressed: () => _onBack(context, ref),
        ),
        title: Text(
          l10n.notificationsTitle,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: colors.borderDefault),
        ),
        actions: [
          IconButton(
            icon: Iconify(Mdi.dots_vertical, color: colors.textPrimary, size: 22),
            onPressed: () => _showOverflowMenu(context, ref),
          ),
        ],
      ),
      body: const _NotificationsBody(),
    );
  }
}

/// Invalidates the header bell's unread count as a safety net, then pops one
/// level, falling back to the home dashboard if there's nothing to pop to.
///
/// The count is already invalidated on every mutation ([NotificationsNotifier]
/// invalidates it after `markRead`/`markAllRead`/`clearAll` succeed), so by
/// the time the user navigates back the badge should already be correct —
/// this just guards against the badge going stale if that invalidation ever
/// raced with something else.
void _onBack(BuildContext context, WidgetRef ref) {
  ref.invalidate(notificationCountProvider);
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(AppRoutes.home);
  }
}

// ---------------------------------------------------------------------------
// Overflow menu
// ---------------------------------------------------------------------------

/// Shows a positioned floating menu below the AppBar with notification actions.
void _showOverflowMenu(BuildContext context, WidgetRef ref) {
  final topOffset = MediaQuery.of(context).padding.top + 8;
  const rightOffset = 12.0;

  unawaited(
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (ctx) => Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(ctx),
              child: const SizedBox.expand(),
            ),
            Positioned(
              top: topOffset,
              right: rightOffset,
              child: _OverflowMenu(
                onMarkAllRead: () async {
                  Navigator.pop(ctx);
                  final success = await ref.read(notificationsProvider.notifier).markAllRead();
                  if (!success && context.mounted) {
                    ref.read(snackbarServiceProvider).showError(context.l10n.notificationsMarkAllReadError);
                  }
                },
                onClearAll: () async {
                  Navigator.pop(ctx);
                  final confirmed = await _confirmClearAll(context);
                  if (confirmed != true) return;
                  final success = await ref.read(notificationsProvider.notifier).clearAll();
                  if (!success && context.mounted) {
                    ref.read(snackbarServiceProvider).showError(context.l10n.notificationsClearAllError);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Floating card with Mark All as Read and Clear All menu items.
class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({
    required this.onMarkAllRead,
    required this.onClearAll,
  });

  final VoidCallback onMarkAllRead;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Container(
      width: 208,
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
        boxShadow: [
          BoxShadow(
            color: colors.bgOverlay.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OverflowMenuItem(
              icon: Mdi.check_all,
              label: l10n.notificationsMenuMarkAllRead,
              color: colors.textPrimary,
              onTap: onMarkAllRead,
            ),
            Divider(height: 1, thickness: 1, color: colors.borderDefault),
            _OverflowMenuItem(
              icon: Mdi.delete_outline,
              label: l10n.notificationsMenuClearAll,
              color: cs.error,
              onTap: onClearAll,
            ),
          ],
        ),
      ),
    );
  }
}

/// Single tappable row inside [_OverflowMenu].
class _OverflowMenuItem extends StatelessWidget {
  const _OverflowMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Iconify(icon, size: 18, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a confirmation dialog before deleting every notification.
///
/// Returns `true` if the user confirmed, `false`/`null` otherwise.
Future<bool?> _confirmClearAll(BuildContext context) {
  final l10n = context.l10n;
  final cs = Theme.of(context).colorScheme;
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.notificationsClearAllConfirmTitle),
      content: Text(l10n.notificationsClearAllConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.commonButtonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(
            l10n.notificationsMenuClearAll,
            style: TextStyle(color: cs.error),
          ),
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

class _NotificationsBody extends ConsumerStatefulWidget {
  const _NotificationsBody();

  @override
  ConsumerState<_NotificationsBody> createState() => _NotificationsBodyState();
}

class _NotificationsBodyState extends ConsumerState<_NotificationsBody> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // notificationsProvider is non-autoDispose (persists across navigation),
    // so re-opening this screen would otherwise keep showing whatever list
    // was fetched on a previous visit. Only force a re-fetch when a previous
    // value is already cached — a first-ever load already fetches via
    // NotificationsNotifier.build(), so triggering this too would double the
    // initial request.
    if (ref.read(notificationsProvider).hasValue) {
      unawaited(_refreshOnOpen());
    }
  }

  /// Silently re-fetches the notification list on screen open. Not
  /// user-initiated, so failures are logged (not surfaced via snackbar) —
  /// the user keeps seeing the cached list from the previous fetch.
  Future<void> _refreshOnOpen() async {
    try {
      await ref.read(notificationsProvider.notifier).refresh();
    } on Object catch (e, s) {
      AppLogger.w('Notifications: refresh-on-open failed, showing cached list', e, s);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;
    final filteredAsync = ref.watch(filteredNotificationsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: AppSearchField(
              controller: _searchController,
              hintText: l10n.notificationsSearchHint,
              onChanged: (v) => ref.read(notificationsSearchProvider.notifier).setQuery(v),
            ),
          ),

          // ── Filter chips ─────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: NotificationFilterChipsRow(),
            ),
          ),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                try {
                  await ref.read(notificationsProvider.notifier).refresh();
                } on Object {
                  if (context.mounted) {
                    ref.read(snackbarServiceProvider).showError(l10n.notificationsRefreshError);
                  }
                }
              },
              // Crossfades the skeleton out as the data arrives instead of
              // cutting to it. The states are distinct widget types, so the
              // switcher detects the change without explicit keys.
              child: AnimatedSwitcher(
                duration: AppMotion.duration(context, AppMotion.base),
                child: filteredAsync.when(
                  loading: () => const NotificationsListShimmer(),
                  error: (e, _) => ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Text(e.toString(), style: TextStyle(color: cs.error)),
                        ),
                      ),
                    ],
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return ListView(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: NoRecordWidget(message: l10n.notificationsEmpty),
                          ),
                        ],
                      );
                    }
                    return ListView(
                      padding: const EdgeInsets.only(top: 12, bottom: 24),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colors.bgCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.borderDefault),
                            boxShadow: [
                              BoxShadow(
                                color: colors.cardShadow,
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              children: [
                                // Rows arrive one at a time rather than the
                                // whole card at once. The card is taller than
                                // the viewport, so rows below the fold wait to
                                // be scrolled to instead of finishing their
                                // entrance unseen. Each card carries its own
                                // divider, so a separator never lands before
                                // the row it separates.
                                for (var i = 0; i < items.length; i++)
                                  SettleIn(
                                    index: i,
                                    revealOnScroll: true,
                                    child: NotificationItemCard(
                                      item: items[i],
                                      isLast: i == items.length - 1,
                                      lang: notificationsLang,
                                      onTap: () => unawaited(
                                        ref.read(notificationsProvider.notifier).markRead(items[i].id),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
