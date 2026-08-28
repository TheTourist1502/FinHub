import 'package:finhub/core/roles/role_experience.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:finhub/shared/widgets/layout/app_bottom_nav.dart';
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
