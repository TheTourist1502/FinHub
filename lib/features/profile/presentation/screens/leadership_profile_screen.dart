import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/profile/presentation/widgets/language_preference_row.dart';
import 'package:finhub/features/profile/presentation/widgets/logout_section.dart';
import 'package:finhub/features/profile/presentation/widgets/profile_header_section.dart';
import 'package:finhub/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:finhub/features/profile/presentation/widgets/security_section.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:flutter/material.dart';

/// Profile screen for a [UserRole.leadership] user.
///
/// Composes the same widgets as the advisor's [ProfileScreen] — header,
/// security, preferences — so avatar upload, security history and the
/// (English-only) language row all behave identically and are maintained in
/// one place.
///
/// Two differences, both deliberate:
///
/// - Preferences is composed here from [LanguagePreferenceRow] alone rather
///   than reusing `PreferencesSection`: country, region and tax jurisdiction
///   describe an advisor's book of business, which a leadership user does not
///   have.
/// - Sign out is a pinned footer rather than the last item in the scroll
///   view: leadership's header carries fewer actions than the advisor's, so
///   this is the discoverable exit and must not depend on scrolling to find
///   it.
class LeadershipProfileScreen extends StatelessWidget {
  /// Creates a [LeadershipProfileScreen].
  const LeadershipProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.surfaceDefault,
      appBar: AppBar(
        backgroundColor: colors.surfaceDefault,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          context.l10n.profileTitle,
          style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w500, color: cs.onSurface),
        ),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: cs.outlineVariant)),
      ),
      body: const Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettleIn(child: ProfileHeaderSection()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettleIn(index: 1, child: SecuritySection()),
                        SizedBox(height: 24),
                        SettleIn(index: 2, revealOnScroll: true, child: _LeadershipPreferencesSection()),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, thickness: 1),
          SafeArea(top: false, child: Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 8), child: LogoutSection())),
        ],
      ),
    );
  }
}

/// Preferences block for the leadership profile — language selection only.
///
/// `isRequired: false` — there is nothing to enforce when language is the
/// only preference, and the row already carries a value. `MandatoryFieldsNote`
/// is omitted for the same reason: no asterisk is drawn, so a legend
/// explaining one would describe something not on screen.
class _LeadershipPreferencesSection extends StatelessWidget {
  const _LeadershipPreferencesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSectionHeader(label: context.l10n.profilePreferencesTitle),
        const SizedBox(height: 12),
        const LanguagePreferenceRow(isRequired: false),
      ],
    );
  }
}
