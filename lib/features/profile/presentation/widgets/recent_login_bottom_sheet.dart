import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/date_display_formatter.dart';
import 'package:finhub/features/profile/domain/models/profile_data.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:intl/intl.dart';

/// Bottom sheet displaying the full recent login history for the user.
///
/// Shown when the security section row is tapped and
/// [ProfileData.recentLogins] contains more than one entry.
class RecentLoginBottomSheet extends StatelessWidget {
  /// Creates a [RecentLoginBottomSheet].
  const RecentLoginBottomSheet({required this.logins, super.key});

  /// Ordered list of recent login sessions (newest first).
  final List<RecentLogin> logins;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: colors.borderDefault, borderRadius: BorderRadius.circular(12))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 4, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.profileLoginHistoryAllTitle.toUpperCase(),
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: colors.textSecondary, letterSpacing: 0.25),
              ),
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: Iconify(Mdi.close, size: 14, color: colors.textSecondary)),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 48),
            itemCount: logins.length,
            separatorBuilder: (_, _) => Divider(height: 1, color: cs.outlineVariant),
            itemBuilder: (_, i) => _LoginEntry(login: logins[i]),
          ),
        ),
      ],
    );
  }
}

/// Single row in [RecentLoginBottomSheet] showing device and timestamp.
class _LoginEntry extends StatelessWidget {
  const _LoginEntry({required this.login});

  final RecentLogin login;

  /// Formats a login timestamp as "MMM d, yyyy · h:mm a" in the device's
  /// time zone.
  String _formatDate(DateTime loginAt) => DateFormat('MMM d, yyyy · h:mm a').formatLocal(loginAt);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: colors.statusInfoBg, borderRadius: BorderRadius.circular(8)),
            child: Center(child: Iconify(Mdi.clock_outline, size: 20, color: colors.statusInfoDefault)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(login.device, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: cs.onSurface)),
                if (login.loginAt case final loginAt?) ...[
                  const SizedBox(height: 2),
                  Text(_formatDate(loginAt), style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: colors.textSecondary)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
