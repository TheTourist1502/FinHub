import 'package:finhub/features/login/domain/models/user.dart';

/// Who may enter a route.
///
/// A route with no policy is protected and open to any authenticated user —
/// the common case needs no declaration.
class RoutePolicy {
  /// Creates a policy. [isPublic] and [roles] are mutually exclusive in
  /// practice: a public route is not role-gated.
  const RoutePolicy({this.isPublic = false, this.roles});

  /// No authentication required.
  final bool isPublic;

  /// Only these roles may enter; anyone else is sent to
  /// [AppRoutes.accessDenied].
  final Set<UserRole>? roles;
}

/// Every named route in the app, plus the access policies over them.
abstract final class AppRoutes {
  /// Sign-in form.
  static const String login = '/login';

  /// Landing route for a signed-in user.
  static const String home = '/home';

  /// Households tab.
  static const String households = '/households';

  /// Real-time positions and activity tab.
  static const String realTime = '/real-time';

  /// A single account's real-time detail, pushed from the Real-Time tab's
  /// account selector. Renders outside the shell so the bottom nav is hidden.
  static const String realTimeDetailedView = '/real-time/:accountId';

  /// Service requests tab — advisors only.
  static const String serviceRequests = '/service-requests';

  /// Commissions tab — leadership only.
  static const String commissions = '/commissions';

  /// Market insights tab.
  static const String insights = '/insights';

  /// Shown when a role check fails.
  static const String accessDenied = '/access-denied';

  /// The new service-request form, pushed from the dashboard's quick actions.
  static const String newServiceRequest = '/service-requests/add';

  /// Service request success screen, pushed after a service request is
  /// submitted. Renders outside the shell so the bottom nav is hidden.
  static const String serviceRequestSuccess = '/service-requests/success';

  /// Full transaction history, pushed from the dashboard's recent-transactions card.
  static const String viewTransactions = '/view-transactions';

  /// The advisor's account list, reachable from a dashboard quick action.
  static const String accounts = '/accounts';

  /// A single account's detail, pushed from an account card.
  static const String accountDetailView = '/accounts/detailed-account-view/:accountId';

  /// A single household's detail, pushed from a household card.
  static const String householdsDetailedView = '/households/detailed-view/:householdId';

  /// The task dashboard, reachable from a dashboard quick action.
  static const String taskDashboard = '/task-dashboard';

  /// The advisor's own commission detail, reachable from a dashboard quick action.
  static const String myCommissions = '/my-commissions';

  /// Every branch of the bottom-navigation shell, in the order the router
  /// registers them.
  ///
  /// A tab's position here is its `StatefulNavigationShell` branch index — the
  /// list is shared by every role, and [RoleExperience] decides which of them
  /// a given role actually sees.
  static const List<String> shellBranches = [home, households, realTime, serviceRequests, commissions, insights];

  /// Non-default access rules, keyed by path. A child route inherits the
  /// nearest ancestor's policy, so only the ancestor needs an entry.
  static const Map<String, RoutePolicy> policies = {
    login: RoutePolicy(isPublic: true),
    accessDenied: RoutePolicy(isPublic: true),
    serviceRequests: RoutePolicy(roles: {UserRole.advisor}),
    commissions: RoutePolicy(roles: {UserRole.leadership}),
    // Backed by the advisor's own account list, with no leadership twin —
    // `/real-time/:accountId` inherits this automatically.
    realTime: RoutePolicy(roles: {UserRole.advisor}),
  };

  /// The policy governing [location], walking up to the nearest ancestor with
  /// one. Returns `null` when the default (protected, any role) applies.
  ///
  /// Any query string is stripped first: `/login?redirect=…` is governed by
  /// `/login`, and treating it as an unknown path would bounce a signed-out
  /// user off the very screen they were sent to.
  static RoutePolicy? policyFor(String location) {
    var path = Uri.parse(location).path;
    while (path.isNotEmpty) {
      final policy = policies[path];
      if (policy != null) return policy;
      final slash = path.lastIndexOf('/');
      if (slash <= 0) break;
      path = path.substring(0, slash);
    }
    return null;
  }
}
