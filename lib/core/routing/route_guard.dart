import 'package:finhub/core/roles/role_experience.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';

/// Decides every redirect in the app. Auth and role checks live here and
/// nowhere else — never inside a screen, widget or notifier.
///
/// [advisorContextRestoring] is `true` while a leadership user's persisted
/// advisor selection is still being read off disk (see
/// `AdvisorContextNotifier`). The answer is not known yet in that window, so
/// this holds the current route rather than acting on a guess — exactly like
/// the [AuthUnknown] hold below.
///
/// [requiresAdvisorSelection] is `true` for a leadership user who has settled
/// on having no advisor picked; every scoped screen has nothing to render
/// until they choose one.
///
/// [firstTimeLoginResolving] is `true` while an advisor's profile fixture —
/// which carries the `firstTimeLogin` flag — is still being fetched. The
/// answer is not known yet in that window, so this holds the current route
/// rather than acting on a guess, exactly like the [advisorContextRestoring]
/// hold above.
///
/// [isFirstTimeLogin] is `true` for an advisor whose profile still reports a
/// first-time login; every protected route but [AppRoutes.welcome] bounces
/// them there until the carousel's "Continue" clears the flag.
///
/// Returns the path to redirect to, or `null` to let the navigation stand.
String? routeGuard({
  required AuthState state,
  required String location,
  bool advisorContextRestoring = false,
  bool requiresAdvisorSelection = false,
  bool firstTimeLoginResolving = false,
  bool isFirstTimeLogin = false,
}) {
  final policy = AppRoutes.policyFor(location);
  final user = state is AuthAuthenticated ? state.user : null;

  // The cold-start session check has not resolved yet; hold the current route
  // rather than flashing the login screen at a user who is signed in.
  if (state is AuthUnknown) return null;

  // Same reasoning as the AuthUnknown hold above: acting before the persisted
  // advisor selection has been read would either flash the picker at a
  // leadership user who already has one, or hand them a scoped screen that
  // has nothing to show yet.
  if (advisorContextRestoring) return null;

  // The profile fixture that carries `firstTimeLogin` is still in flight, so
  // the check below would read a `false` that only means "not known yet".
  if (firstTimeLoginResolving) return null;

  if (user == null) {
    if (policy?.isPublic ?? false) return null;
    // Preserve where they were heading, so login can finish the journey.
    return '${AppRoutes.login}?redirect=${Uri.encodeComponent(location)}';
  }

  // A signed-in user has no business on the login screen. Compare paths, not
  // prefixes — `/login-help` is a different route, not this one.
  if (Uri.parse(location).path == AppRoutes.login) return RoleExperience.landingRouteFor(user.role);

  final roles = policy?.roles;
  if (roles != null && !roles.contains(user.role)) return AppRoutes.accessDenied;

  // Rule 6: advisor-selection gate. Runs after the role check so a genuine
  // access violation still resolves to /access-denied rather than being
  // masked by the picker.
  if (requiresAdvisorSelection && Uri.parse(location).path != AppRoutes.selectAdvisor) {
    return AppRoutes.selectAdvisor;
  }

  // Rule 7: welcome-carousel gate. Mirrors rule 6, mutually exclusive with it
  // by role — an advisor with a first-time-login profile is sent through
  // onboarding before any other protected route.
  if (isFirstTimeLogin && Uri.parse(location).path != AppRoutes.welcome) {
    return AppRoutes.welcome;
  }

  return null;
}
