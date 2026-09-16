import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// App bar for [LeadershipAdvisorSelectionScreen].
///
/// The leading slot depends on how the screen was reached:
///
/// * **First selection after login** — the route guard redirected here with
///   nothing to pop to, so the leading slot carries the app mark.
/// * **Switching advisors** — the picker was pushed from elsewhere, so a back
///   arrow returns to the tab the switch was started from.
///
/// Sign-out stays available either way: on the guard-redirect path this is
/// the only way out of the app if the advisor list cannot load.
class AdvisorSelectionAppBar extends ConsumerWidget implements PreferredSizeWidget {
  /// Creates an [AdvisorSelectionAppBar].
  const AdvisorSelectionAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final canGoBack = context.canPop();

    return Container(
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 4),
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: Row(
        children: [
          if (canGoBack)
            Semantics(
              button: true,
              label: MaterialLocalizations.of(context).backButtonTooltip,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.pop(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Iconify(Mdi.arrow_left, color: cs.onSurface),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Iconify(Mdi.finance, color: cs.primary, size: 28),
            ),
          Expanded(
            child: Text(
              l10n.selectAdvisorTitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: Iconify(Mdi.logout, size: 20, color: cs.onSurface),
            tooltip: l10n.profileSignOutButton,
            onPressed: () => ref.read(authNotifierProvider.notifier).signOut(context),
          ),
        ],
      ),
    );
  }
}
