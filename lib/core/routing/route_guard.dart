import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';

/// Decides every redirect in the app. Auth and role checks live here and
/// nowhere else — never inside a screen, widget or notifier.
///
/// Returns the path to redirect to, or `null` to let the navigation stand.
String? routeGuard({required AuthState state, required String location}) {
  final policy = AppRoutes.policyFor(location);
  final user = state is AuthAuthenticated ? state.user : null;

  // The cold-start session check has not resolved yet; hold the current route
  // rather than flashing the login screen at a user who is signed in.
  if (state is AuthUnknown) return null;

  if (user == null) {
    if (policy?.isPublic ?? false) return null;
    // Preserve where they were heading, so login can finish the journey.
    return '${AppRoutes.login}?redirect=${Uri.encodeComponent(location)}';
  }

  // A signed-in user has no business on the login screen.
  if (location.startsWith(AppRoutes.login)) return AppRoutes.home;

  final roles = policy?.roles;
  if (roles != null && !roles.contains(user.role)) return AppRoutes.accessDenied;

  return null;
}
