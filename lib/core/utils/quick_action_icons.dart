/// Icon resolver for quick-action keys.
///
/// Returns the compile-time MDI SVG string that corresponds to a given
/// `quickActionKey` as returned by `GET /v1/profile/personalization`.
library;

import 'package:iconify_flutter/icons/mdi.dart';

/// Returns the MDI SVG string for [quickActionKey].
///
/// Falls back to [Mdi.flash] for any key not yet mapped.
String quickActionIconSvg(String quickActionKey) => switch (quickActionKey) {
  'client_search' => Mdi.account_search,
  'tasks_dashboard' => Mdi.clipboard_check_outline,
  'commissions' => Mdi.cash_multiple,
  'meeting_notes' => Mdi.notebook_outline,
  'account_maintenance' => Mdi.account_cog_outline,
  'asset_movement' => Mdi.swap_horizontal,
  'online_access' => Mdi.monitor_account,
  'investor_portal' => Mdi.open_in_new,
  _ => Mdi.flash,
};
