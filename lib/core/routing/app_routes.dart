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

  /// Shown when a role check fails.
  static const String accessDenied = '/access-denied';

  /// Non-default access rules, keyed by path. A child route inherits the
  /// nearest ancestor's policy, so only the ancestor needs an entry.
  static const Map<String, RoutePolicy> policies = {
    login: RoutePolicy(isPublic: true),
    accessDenied: RoutePolicy(isPublic: true),
  };

  /// The policy governing [location], walking up to the nearest ancestor with
  /// one. Returns `null` when the default (protected, any role) applies.
  static RoutePolicy? policyFor(String location) {
    var path = location;
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
