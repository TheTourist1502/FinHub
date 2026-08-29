/// Label resolver for quick-action keys.
///
/// Returns the localised display label that corresponds to a given
/// `quickActionKey` as returned by `GET /v1/profile/personalization`.
library;

import 'package:finhub/generated/l10n/app_localizations.dart';

/// Returns the localised label for [quickActionKey] using [l10n].
///
/// Falls back to [quickActionKey] itself for any key not yet mapped.
String quickActionLabel(AppLocalizations l10n, String quickActionKey) => switch (quickActionKey) {
  'client_search' => l10n.dashboardQuickActionClientSearch,
  'tasks_dashboard' => l10n.dashboardQuickActionTasksDashboard,
  'commissions' => l10n.dashboardQuickActionMyCommissions,
  'meeting_notes' => l10n.dashboardQuickActionMeetingNotes,
  'account_maintenance' => l10n.dashboardQuickActionAccountMaintenance,
  'asset_movement' => l10n.dashboardQuickActionAssetMovement,
  'online_access' => l10n.dashboardQuickActionOnlineAccess,
  'investor_portal' => l10n.dashboardQuickActionInvestorPortal,
  _ => quickActionKey,
};
