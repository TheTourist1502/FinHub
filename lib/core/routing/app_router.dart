import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/routing/route_guard.dart';
import 'package:finhub/features/access_denied/presentation/screens/access_denied_screen.dart';
import 'package:finhub/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:finhub/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:finhub/features/home/presentation/screens/coming_soon_screen.dart';
import 'package:finhub/features/home/presentation/screens/home_shell_screen.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:finhub/features/login/presentation/screens/login_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The app's [GoRouter].
///
/// Every redirect decision is delegated to [routeGuard]; this file only maps
/// paths to screens.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterChangeNotifier(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refresh,
    redirect: (context, routerState) =>
        routeGuard(state: ref.read(authNotifierProvider), location: routerState.uri.toString()),
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, routerState) => LoginScreen(redirectTo: routerState.uri.queryParameters['redirect']),
      ),
      GoRoute(path: AppRoutes.accessDenied, builder: (context, routerState) => const AccessDeniedScreen()),
      // Pushed above the shell from the dashboard. Their screens land on their
      // own days; until then the destination is the coming-soon placeholder.
      GoRoute(
        path: AppRoutes.newServiceRequest,
        builder: (context, routerState) => ComingSoonScreen(tabLabel: context.l10n.navServiceRequests),
      ),
      GoRoute(
        path: AppRoutes.viewTransactions,
        builder: (context, routerState) => ComingSoonScreen(tabLabel: context.l10n.viewTransactionsTitle),
      ),
      GoRoute(
        path: AppRoutes.accounts,
        builder: (context, routerState) => const AccountsScreen(),
      ),
      GoRoute(
        path: AppRoutes.accountDetailView,
        builder: (context, routerState) => ComingSoonScreen(tabLabel: context.l10n.dashboardViewDetails),
      ),
      GoRoute(
        path: AppRoutes.taskDashboard,
        builder: (context, routerState) => ComingSoonScreen(tabLabel: context.l10n.dashboardQuickActionTasksDashboard),
      ),
      GoRoute(
        path: AppRoutes.myCommissions,
        builder: (context, routerState) => ComingSoonScreen(tabLabel: context.l10n.dashboardQuickActionMyCommissions),
      ),
      // One branch per entry in AppRoutes.shellBranches, in that order — the
      // shell maps a role's tabs back to these indexes.
      StatefulShellRoute.indexedStack(
        builder: (context, routerState, navigationShell) => HomeShellScreen(navigationShell: navigationShell),
        branches: [
          _branch(AppRoutes.home, (context) => const DashboardScreen()),
          _branch(AppRoutes.households, (context) => ComingSoonScreen(tabLabel: context.l10n.navHouseholds)),
          _branch(AppRoutes.realTime, (context) => ComingSoonScreen(tabLabel: context.l10n.navRealTime)),
          _branch(AppRoutes.serviceRequests, (context) => ComingSoonScreen(tabLabel: context.l10n.navServiceRequests)),
          _branch(AppRoutes.commissions, (context) => ComingSoonScreen(tabLabel: context.l10n.navCommissions)),
          _branch(AppRoutes.insights, (context) => ComingSoonScreen(tabLabel: context.l10n.navInsights)),
        ],
      ),
    ],
  );
});

/// A shell branch holding a single root route. Child routes of a tab are added
/// to its `routes:` list as that feature grows.
StatefulShellBranch _branch(String path, Widget Function(BuildContext context) builder) =>
    StatefulShellBranch(routes: [GoRoute(path: path, builder: (context, routerState) => builder(context))]);

/// Re-runs the router's redirect whenever the session state changes.
class _RouterChangeNotifier extends ChangeNotifier {
  _RouterChangeNotifier(Ref ref) {
    _subscription = ref.listen(authNotifierProvider, (_, _) => notifyListeners());
  }

  late final ProviderSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
