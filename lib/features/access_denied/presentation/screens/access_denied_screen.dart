import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Shown when a role check in [routeGuard] refuses a destination.
class AccessDeniedScreen extends StatelessWidget {
  /// Creates the screen.
  const AccessDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Iconify(Mdi.lock_outline, color: colors.iconSecondary, size: 48),
                const SizedBox(height: AppDimensions.spaceMd),
                Text(
                  context.l10n.accessDeniedTitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.emptyStateTitle.copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                Text(
                  context.l10n.accessDeniedMessage,
                  textAlign: TextAlign.center,
                  style: AppTypography.emptyStateDescription.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                FilledButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: Text(context.l10n.accessDeniedBackButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
