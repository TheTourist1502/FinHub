import 'dart:async';

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/date_display_formatter.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:finhub/features/profile/presentation/widgets/profile_row_item.dart';
import 'package:finhub/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:finhub/features/profile/presentation/widgets/recent_login_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:intl/intl.dart';

/// Profile section that shows account security information.
///
/// Displays the Login History row with the most recent login timestamp. When
/// [ProfileData.recentLogins] contains more than one entry, a chevron opens
/// [RecentLoginBottomSheet] showing the full history.
class SecuritySection extends ConsumerWidget {
  /// Creates a [SecuritySection].
  const SecuritySection({super.key});

  /// Formats a login timestamp as "MMM d, h:mm a" in the device's time zone.
  static String _formatLoginDate(DateTime loginAt) => DateFormat('MMM d, h:mm a').formatLocal(loginAt);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final profile = ref.watch(currentProfileProvider).value;
    final logins = profile?.recentLogins ?? const [];
    final hasMultiple = logins.length > 1;

    // The "last login on <date>" subtitle needs a real date to be worth
    // showing. With no logins, or a most-recent login the fixture dated
    // unusably, fall back to the generic subtitle rather than naming a
    // timestamp that does not exist.
    final lastLoginAt = logins.isNotEmpty ? logins.first.loginAt : null;
    final subtitleText = lastLoginAt != null
        ? context.l10n.profileLastLoginOn(_formatLoginDate(lastLoginAt))
        : context.l10n.profileLoginHistorySubtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSectionHeader(label: context.l10n.profileSecurityAccessTitle),
        const SizedBox(height: 12),
        ProfileSectionCard(
          child: GestureDetector(
            onTap: hasMultiple
                ? () => unawaited(
                    showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
                      builder: (_) => RecentLoginBottomSheet(logins: logins),
                    ),
                  )
                : null,
            child: ProfileRowItem(
              iconBgColor: colors.statusInfoBg,
              iconWidget: Iconify(Mdi.history, size: 20, color: colors.statusInfoDefault),
              title: context.l10n.profileLoginHistoryTitle,
              subtitle: subtitleText,
              trailing: hasMultiple ? Iconify(Mdi.chevron_right, size: 16, color: colors.textSecondary) : null,
            ),
          ),
        ),
      ],
    );
  }
}
