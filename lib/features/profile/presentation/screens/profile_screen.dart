import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/profile/presentation/widgets/preferences_section.dart';
import 'package:finhub/features/profile/presentation/widgets/profile_header_section.dart';
import 'package:finhub/features/profile/presentation/widgets/security_section.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:flutter/material.dart';

/// Full-screen profile view pushed from the avatar in the home shell header.
///
/// Displays the advisor's avatar, name, FA role badge, security history,
/// and preferences (country, region, language). All business logic is
/// delegated to child section widgets and their providers.
class ProfileScreen extends StatelessWidget {
  /// Creates a [ProfileScreen].
  const ProfileScreen({super.key});

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
      // Only the three sections carry motion. The rows inside them are
      // settings controls, not content arriving — they read better static.
      // Preferences is the tallest section and starts below the fold on a
      // short device, so it waits to be scrolled to.
      body: const SingleChildScrollView(
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
                  SettleIn(index: 2, revealOnScroll: true, child: PreferencesSection()),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
