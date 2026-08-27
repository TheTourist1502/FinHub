import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Landing screen for a signed-in user.
///
/// A placeholder that proves the session spine end to end: it names who is
/// signed in, with what role, over which advisor's book, and can end the
/// session. The real dashboard replaces its body.
class DashboardScreen extends ConsumerWidget {
  /// Creates the screen.
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appName)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.dashboardGreeting(user?.name ?? ''),
                  textAlign: TextAlign.center,
                  style: AppTypography.pageTitle.copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                Text(
                  l10n.dashboardSessionSummary(user?.role.name ?? '', user?.advisorId ?? '—'),
                  textAlign: TextAlign.center,
                  style: AppTypography.pageSubtitle.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: AppDimensions.spaceXl),
                OutlinedButton(
                  onPressed: () => ref.read(authNotifierProvider.notifier).signOut(context),
                  child: Text(l10n.authSignOutButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
