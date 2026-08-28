import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Stands in for a shell branch whose feature has not shipped yet.
///
/// One widget serves every unbuilt tab: the shell needs a route target per
/// branch, and five near-empty screens would be five files to delete later.
/// Each feature replaces its own branch as it lands.
class ComingSoonScreen extends StatelessWidget {
  /// Creates the placeholder for the tab named [tabLabel].
  const ComingSoonScreen({required this.tabLabel, super.key});

  /// The localised name of the tab, shown in the heading.
  final String tabLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(title: Text(tabLabel)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.comingSoonTitle(tabLabel),
                  textAlign: TextAlign.center,
                  style: AppTypography.emptyStateTitle.copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                Text(
                  context.l10n.comingSoonMessage,
                  textAlign: TextAlign.center,
                  style: AppTypography.emptyStateDescription.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
