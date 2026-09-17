import 'package:finhub/core/advisor_context/advisor_context_provider.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/routing/route_guard.dart';
import 'package:finhub/features/access_denied/presentation/screens/access_denied_screen.dart';
import 'package:finhub/features/account_detail_view/presentation/screens/account_detail_screen.dart';
import 'package:finhub/features/accounts/domain/models/account.dart';
import 'package:finhub/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/screens/commissions_detailed_view_screen.dart';
import 'package:finhub/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:finhub/features/home/presentation/screens/coming_soon_screen.dart';
import 'package:finhub/features/home/presentation/screens/home_shell_screen.dart';
import 'package:finhub/features/households/domain/models/household_detail.dart';
import 'package:finhub/features/households/presentation/screens/households_list_screen.dart';
import 'package:finhub/features/households/presentation/screens/households_shell_screen.dart';
import 'package:finhub/features/households_detailed_view/presentation/screens/household_detail_screen.dart';
import 'package:finhub/features/leadership_advisor_selection/presentation/screens/leadership_advisor_selection_screen.dart';
import 'package:finhub/features/leadership_commissions/presentation/screens/leadership_commissions_screen.dart';
import 'package:finhub/features/login/domain/models/user.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:finhub/features/login/presentation/screens/login_screen.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_summary.dart';
import 'package:finhub/features/my_commissions/presentation/screens/my_commissions_screen.dart';
import 'package:finhub/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:finhub/features/profile/domain/models/profile_data.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:finhub/features/profile/presentation/screens/leadership_profile_screen.dart';
import 'package:finhub/features/profile/presentation/screens/profile_screen.dart';
import 'package:finhub/features/real_time/presentation/screens/real_time_screen.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/screens/real_time_detailed_view_screen.dart';
import 'package:finhub/features/task_dashboard/presentation/screens/task_dashboard_screen.dart';
import 'package:finhub/features/view_transactions/presentation/screens/view_transaction_screen.dart';
import 'package:finhub/features/welcome/presentation/screens/welcome_screen.dart';
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
    redirect: (context, routerState) {
      final authState = ref.read(authNotifierProvider);
      final user = authState is AuthAuthenticated ? authState.user : null;
      final advisorContext = ref.read(advisorContextProvider);
      // Only an advisor's profile carries a welcome carousel to gate on —
      // leadership takes the advisor-selection gate above instead — so this
      // stays unread (and its fetch never fires) for a leadership session.
      final profile = user?.role == UserRole.advisor ? ref.read(currentProfileProvider) : null;
      return routeGuard(
        state: authState,
        location: routerState.uri.toString(),
        advisorContextRestoring: advisorContext.isRestoring,
        requiresAdvisorSelection: user?.role == UserRole.leadership && advisorContext.advisorId == null,
        firstTimeLoginResolving: profile?.isLoading ?? false,
        isFirstTimeLogin: profile?.value?.isFirstTimeLogin ?? false,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, routerState) => LoginScreen(redirectTo: routerState.uri.queryParameters['redirect']),
      ),
      GoRoute(path: AppRoutes.accessDenied, builder: (context, routerState) => const AccessDeniedScreen()),
      GoRoute(
        path: AppRoutes.selectAdvisor,
        builder: (context, routerState) => const LeadershipAdvisorSelectionScreen(),
      ),
      GoRoute(path: AppRoutes.welcome, builder: (context, routerState) => const WelcomeScreen()),
      GoRoute(
        path: AppRoutes.viewTransactions,
        builder: (context, routerState) => const ViewTransactionScreen(),
      ),
      // The tapped account is passed as `extra` (from the accounts list or a
      // household's top-accounts row) so the detail screen renders its top
      // card and asset-allocation chart without a second fixture read.
      GoRoute(
        path: AppRoutes.accountDetailView,
        builder: (context, routerState) => AccountDetailScreen(
          accountId: routerState.pathParameters['accountId'] ?? '',
          account: routerState.extra as Account?,
        ),
      ),
      // The tapped household is passed as `extra` from the households list
      // so the detail screen renders its top card and asset-allocation chart
      // without a second fixture read.
      GoRoute(
        path: AppRoutes.householdsDetailedView,
        builder: (context, routerState) => HouseholdDetailScreen(
          householdId: routerState.pathParameters['householdId'] ?? '',
          household: routerState.extra as HouseholdDetail?,
        ),
      ),
      GoRoute(
        path: AppRoutes.realTimeDetailedView,
        builder: (context, routerState) =>
            RealTimeDetailedViewScreen(accountId: routerState.pathParameters['accountId'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.taskDashboard,
        builder: (context, routerState) =>
            TaskDashboardScreen(initialTaskId: routerState.uri.queryParameters['taskId']),
      ),
      // My Commissions — pushed from the dashboard quick-actions bar.
      // Renders outside the shell so the bottom nav is hidden.
      GoRoute(
        path: AppRoutes.myCommissions,
        builder: (context, routerState) => const MyCommissionsScreen(),
      ),
      // Commission Detailed View — pushed from the My Commissions details tab
      // (either mount point). `:accountId` maps to the account ID used to
      // fetch detail data. The `CommissionSummary` tapped on the details tab
      // is passed as `extra` so the header card can render without a second
      // fixture read.
      GoRoute(
        path: AppRoutes.commissionDetailedView,
        builder: (context, routerState) => CommissionsDetailedViewScreen(
          summary: routerState.extra! as CommissionSummary,
        ),
      ),
      // Pushed from the header bell icon. Renders outside the shell so the
      // bottom nav is hidden.
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, routerState) => const NotificationsScreen(),
      ),
      // Profile — pushed from the header avatar. One path, one of two
      // screens: keeping `/profile` single means the header avatar and any
      // deep link stay role-agnostic, and only the content widget differs.
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, routerState) => Consumer(
          builder: (context, ref, child) =>
              ref.watch(currentUserProvider)?.role == UserRole.leadership
              ? const LeadershipProfileScreen()
              : const ProfileScreen(),
        ),
      ),
      // One branch per entry in AppRoutes.shellBranches, in that order — the
      // shell maps a role's tabs back to these indexes.
      StatefulShellRoute.indexedStack(
        builder: (context, routerState, navigationShell) => HomeShellScreen(navigationShell: navigationShell),
        branches: [
          _branch(AppRoutes.home, (context) => const DashboardScreen()),
          _householdsBranch(),
          _branch(AppRoutes.realTime, (context) => const RealTimeScreen()),
          _branch(AppRoutes.commissions, (context) => const LeadershipCommissionsScreen()),
          // Markets tab content lands on its own day.
          _branch(AppRoutes.markets, (context) => ComingSoonScreen(tabLabel: context.l10n.navMarkets)),
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


/// Re-runs the router's redirect whenever the session state, the leadership
/// advisor selection, or the signed-in advisor's profile fetch changes — the
/// last of which is what releases the [firstTimeLoginResolving] hold once
/// the fixture read lands.
class _RouterChangeNotifier extends ChangeNotifier {
  _RouterChangeNotifier(Ref ref) {
    _authSubscription = ref.listen(authNotifierProvider, (_, _) => notifyListeners());
    _advisorSubscription = ref.listen(advisorContextProvider, (_, _) => notifyListeners());
    _profileSubscription = ref.listen(currentProfileProvider, (_, _) => notifyListeners());
  }

  late final ProviderSubscription<AuthState> _authSubscription;
  late final ProviderSubscription<AdvisorContext> _advisorSubscription;
  late final ProviderSubscription<AsyncValue<ProfileData>> _profileSubscription;

  @override
  void dispose() {
    _authSubscription.close();
    _advisorSubscription.close();
    _profileSubscription.close();
    super.dispose();
  }
}
