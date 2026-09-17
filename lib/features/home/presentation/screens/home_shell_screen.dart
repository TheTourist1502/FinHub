import 'package:finhub/core/roles/role_experience.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:finhub/shared/widgets/brand/app_logos.dart';
import 'package:finhub/shared/widgets/layout/app_bottom_nav.dart';
import 'package:finhub/shared/widgets/layout/user_avatar_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Hosts the bottom-navigation shell: the tab bar plus whichever branch is
/// currently on screen.
///
/// The router registers one branch per entry in [AppRoutes.shellBranches] —
/// every role shares that list — and this screen shows only the tabs
/// [RoleExperience] gives the signed-in role, mapping each back to its branch
/// index.
class HomeShellScreen extends ConsumerWidget {
  /// Creates the shell around [navigationShell].
  const HomeShellScreen({required this.navigationShell, super.key});

  /// The shell handed over by `StatefulShellRoute`, owning one navigator per
  /// branch so each tab keeps its own history.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    // Only reachable behind the route guard, so a null user means the guard is
    // mid-redirect; render the branch without chrome rather than crashing.
    if (user == null) return navigationShell;

    final tabs = RoleExperience.tabsFor(user.role);
    final branchIndexes = [for (final tab in tabs) AppRoutes.shellBranches.indexOf(tab.route)];
    // A branch outside this role's tabs (reached by deep link) leaves no tab
    // selected; fall back to the first so the bar always has a valid index.
    final selected = branchIndexes.indexOf(navigationShell.currentIndex);

    return Scaffold(
      // Shown for both roles now that the profile screen gives the avatar
      // somewhere to go; the bell inside it stays advisor-only, since
      // `/notifications`'s unread count is computed for the advisor's own
      // book, which leadership has no equivalent of (see AppRoutes.policies).
      appBar: const _HomeShellHeaderBar(),
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        tabs: tabs,
        currentIndex: selected < 0 ? 0 : selected,
        // `initialLocation: true` on a re-tap pops that tab back to its root,
        // which is what a second tap on the current tab should do.
        onTap: (index) =>
            navigationShell.goBranch(branchIndexes[index], initialLocation: branchIndexes[index] == navigationShell.currentIndex),
      ),
    );
  }
}

/// Shared header bar: brand wordmark on the left, profile-avatar entry point
/// (both roles) on the right.
class _HomeShellHeaderBar extends ConsumerWidget implements PreferredSizeWidget {
  const _HomeShellHeaderBar();

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final topPad = MediaQuery.of(context).padding.top;
    final user = ref.watch(currentUserProvider);
    // Watching currentProfileProvider here also warms it up before the user
    // ever taps through to /profile.
    final profile = ref.watch(currentProfileProvider).value;
    final displayName = (profile?.fullName.isNotEmpty ?? false) ? profile!.fullName : (user?.name ?? '');

    return Container(
      height: preferredSize.height + topPad,
      padding: EdgeInsets.only(top: topPad, left: 16, right: 16),
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      // Transparent Material so the InkWell splash paints above the
      // container's opaque background instead of behind it.
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            const AppWordmarkLogo(width: 120),
            const Spacer(),
            InkWell(
              onTap: () => context.push(AppRoutes.profile),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: UserAvatarBadge(initials: _initials(displayName), avatarUrl: profile?.avatarUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Derives up to two initials from [name] for the avatar's fallback.
  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'[\s.]+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
