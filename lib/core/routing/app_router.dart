import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/routing/route_guard.dart';
import 'package:finhub/features/access_denied/presentation/screens/access_denied_screen.dart';
import 'package:finhub/features/account_detail_view/presentation/screens/account_detail_screen.dart';
import 'package:finhub/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:finhub/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:finhub/features/home/presentation/screens/coming_soon_screen.dart';
import 'package:finhub/features/home/presentation/screens/home_shell_screen.dart';
import 'package:finhub/features/households/presentation/screens/households_list_screen.dart';
import 'package:finhub/features/households/presentation/screens/households_shell_screen.dart';
import 'package:finhub/features/households_detailed_view/presentation/screens/household_detail_screen.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:finhub/features/login/presentation/screens/login_screen.dart';
import 'package:finhub/features/real_time/presentation/screens/real_time_screen.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/screens/real_time_detailed_view_screen.dart';
import 'package:finhub/features/service_request/presentation/screens/service_request_list_screen.dart';
import 'package:finhub/features/service_request/presentation/screens/service_request_success_screen.dart';
import 'package:finhub/features/view_transactions/presentation/screens/view_transaction_screen.dart';
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
      // Pushed once a service request is submitted. `extra` carries the
      // record id; a hot restart (or GoRouter replaying the last known path
      // on engine re-attach) can re-invoke this route with no `extra` at
      // all, bypassing `redirect` entirely — [_ExtraArgsGuard] is the last
      // line of defence, see its doc comment.
      GoRoute(
        path: AppRoutes.serviceRequestSuccess,
        redirect: (context, routerState) =>
            routerState.extra is ServiceRequestSuccessArgs ? null : AppRoutes.serviceRequests,
        builder: (context, routerState) => _ExtraArgsGuard<ServiceRequestSuccessArgs>(
          extra: routerState.extra,
          fallback: AppRoutes.serviceRequests,
          builder: (context, args) => ServiceRequestSuccessScreen(args: args),
        ),
      ),
      GoRoute(
        path: AppRoutes.viewTransactions,
        builder: (context, routerState) => const ViewTransactionScreen(),
      ),
      GoRoute(
        path: AppRoutes.accountDetailView,
        builder: (context, routerState) =>
            AccountDetailScreen(accountId: routerState.pathParameters['accountId'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.householdsDetailedView,
        builder: (context, routerState) =>
            HouseholdDetailScreen(householdId: routerState.pathParameters['householdId'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.realTimeDetailedView,
        builder: (context, routerState) =>
            RealTimeDetailedViewScreen(accountId: routerState.pathParameters['accountId'] ?? ''),
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
          _householdsBranch(),
          _branch(AppRoutes.realTime, (context) => const RealTimeScreen()),
          _branch(AppRoutes.serviceRequests, (context) => const ServiceRequestListScreen()),
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

/// The Households branch: a pathless [ShellRoute] wrapping both
/// `AppRoutes.households` and `AppRoutes.accounts`, so [HouseholdsShellScreen]
/// mounts the pill switcher and the shared search box once and only the
/// routed tab content underneath it transitions.
StatefulShellBranch _householdsBranch() => StatefulShellBranch(
  routes: [
    ShellRoute(
      builder: (context, routerState, child) =>
          HouseholdsShellScreen(location: routerState.uri, child: child),
      routes: [
        GoRoute(path: AppRoutes.households, builder: (context, routerState) => const HouseholdsListScreen()),
        GoRoute(path: AppRoutes.accounts, builder: (context, routerState) => const AccountsScreen()),
      ],
    ),
  ],
);

/// Guards a route whose screen depends on an `extra` payload of type [T].
///
/// `extra` is an in-memory-only Dart object — it is never encoded into the
/// URL, so it cannot survive anything that makes GoRouter rebuild the current
/// location from its path alone (a hot restart, or the engine replaying the
/// last known route to a freshly-constructed [GoRouter] on re-attach). When
/// that happens this route's `builder` is re-invoked with `extra: null`,
/// bypassing the route's own `redirect` (which only runs on the original
/// navigation). Rather than let a cast throw, this widget renders [builder]
/// when [extra] is a valid [T] and otherwise redirects to [fallback] on the
/// next frame, showing a brief spinner in the meantime.
class _ExtraArgsGuard<T extends Object> extends StatefulWidget {
  /// Creates an [_ExtraArgsGuard].
  const _ExtraArgsGuard({required this.extra, required this.fallback, required this.builder});

  /// The route's `state.extra`, expected to be a [T].
  final Object? extra;

  /// Path to redirect to when [extra] is missing or the wrong type.
  final String fallback;

  /// Builds the real screen once [extra] has been confirmed to be a [T].
  final Widget Function(BuildContext context, T args) builder;

  @override
  State<_ExtraArgsGuard<T>> createState() => _ExtraArgsGuardState<T>();
}

class _ExtraArgsGuardState<T extends Object> extends State<_ExtraArgsGuard<T>> {
  @override
  void initState() {
    super.initState();
    if (widget.extra is! T) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(widget.fallback);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final extra = widget.extra;
    if (extra is T) return widget.builder(context, extra);
    // Redirect is already scheduled in initState; this frame renders nothing
    // rather than pulling in a Material dependency just for a spinner.
    return const SizedBox.shrink();
  }
}

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
