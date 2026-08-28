import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/roles/role_experience.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

/// The app's bottom navigation bar.
///
/// Purely presentational: it renders the [tabs] it is handed and reports taps
/// by index. Which tabs exist is [RoleExperience]'s decision, and what a tap
/// does is the shell's.
class AppBottomNav extends StatelessWidget {
  /// Creates the bar.
  const AppBottomNav({required this.tabs, required this.currentIndex, required this.onTap, super.key});

  /// The destinations to show, in display order.
  final List<AppTab> tabs;

  /// Index into [tabs] of the destination currently on screen.
  final int currentIndex;

  /// Called with the tapped index.
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppTypography.navigationLabel.copyWith(
            color: states.contains(WidgetState.selected) ? colors.iconAccent : colors.textSecondary,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: colors.surfaceDefault,
        destinations: [
          for (final (index, tab) in tabs.indexed)
            NavigationDestination(
              // The label doubles as the semantics label, so the icon needs no
              // separate one.
              icon: Iconify(tab.icon, color: index == currentIndex ? colors.iconAccent : colors.iconSecondary),
              label: tab.label(l10n),
            ),
        ],
      ),
    );
  }
}
