import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/routing/route_guard.dart';
import 'package:finhub/features/access_denied/presentation/screens/access_denied_screen.dart';
import 'package:finhub/features/dashboard/presentation/screens/dashboard_screen.dart';
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
      GoRoute(path: AppRoutes.home, builder: (context, routerState) => const DashboardScreen()),
      GoRoute(path: AppRoutes.accessDenied, builder: (context, routerState) => const AccessDeniedScreen()),
    ],
  );
});

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
