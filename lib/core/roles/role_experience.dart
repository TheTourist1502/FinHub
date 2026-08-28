import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/features/login/domain/models/user.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// One destination in the bottom navigation bar.
class AppTab {
  /// Creates a tab.
  const AppTab({required this.route, required this.icon, required this.label});

  /// The branch route this tab switches to. Must be one of
  /// [AppRoutes.shellBranches].
  final String route;

  /// The `mdi` glyph shown above the label.
  final String icon;

  /// Resolves the tab's localised label.
  final String Function(AppLocalizations l10n) label;
}

/// What each role's app looks like: which tabs they get, and where they land
/// after signing in.
///
/// This is the only place a role decides *shape*. Access is still enforced by
/// [AppRoutes.policies] through the route guard — hiding a tab is a
/// convenience, never the gate.
abstract final class RoleExperience {
  /// The bottom-navigation tabs for [role], in display order.
  static List<AppTab> tabsFor(UserRole role) => [
    AppTab(route: AppRoutes.home, icon: Mdi.home_outline, label: (l10n) => l10n.navHome),
    AppTab(route: AppRoutes.households, icon: Mdi.account_group_outline, label: (l10n) => l10n.navHouseholds),
    AppTab(route: AppRoutes.realTime, icon: Mdi.chart_line, label: (l10n) => l10n.navRealTime),
    // The fourth slot is where the two experiences diverge: an advisor raises
    // service requests, leadership watches commissions.
    if (role == UserRole.advisor)
      AppTab(route: AppRoutes.serviceRequests, icon: Mdi.clipboard_text_outline, label: (l10n) => l10n.navServiceRequests)
    else
      AppTab(route: AppRoutes.commissions, icon: Mdi.cash_multiple, label: (l10n) => l10n.navCommissions),
    AppTab(route: AppRoutes.insights, icon: Mdi.newspaper_variant_outline, label: (l10n) => l10n.navInsights),
  ];

  /// Where [role] lands after signing in — always their first tab.
  static String landingRouteFor(UserRole role) => tabsFor(role).first.route;
}
