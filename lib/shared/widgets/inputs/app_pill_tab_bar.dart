import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Segmented pill tab switcher matching the Figma design (node 1113:2506).
///
/// Renders [tabs] as equal-width segments inside a rounded container; the
/// segment at [selectedIndex] is filled with the brand colour and the rest are
/// plain text. [onTabSelected] fires for every tab, including the one already
/// selected — a caller that navigates on selection guards for that itself.
class AppPillTabBar extends StatelessWidget {
  /// Creates an [AppPillTabBar].
  const AppPillTabBar({
    required this.selectedIndex,
    required this.tabs,
    required this.onTabSelected,
    super.key,
  });

  /// Index within [tabs] of the currently active segment.
  final int selectedIndex;

  /// Labels of the segments, left to right. Already localised.
  final List<String> tabs;

  /// Invoked with the index of the tapped segment.
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Row(
        children: [
          for (final (index, label) in tabs.indexed)
            Expanded(
              child: _PillTab(
                label: label,
                isActive: index == selectedIndex,
                onTap: () => onTabSelected(index),
              ),
            ),
        ],
      ),
    );
  }
}

/// A single animated segment within [AppPillTabBar].
///
/// Fill and label are animated on the same token so the text colour cannot
/// snap ahead of the background it sits on.
class _PillTab extends StatelessWidget {
  const _PillTab({required this.label, required this.isActive, required this.onTap});

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final duration = AppMotion.duration(context, AppMotion.quick);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: duration,
        curve: AppMotion.enter,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? colors.bgBrandNavyBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? [BoxShadow(color: colors.cardShadow, blurRadius: 1, offset: const Offset(0, 1))] : null,
        ),
        child: AnimatedDefaultTextStyle(
          duration: duration,
          curve: AppMotion.enter,
          style: AppTypography.buttonMedium.copyWith(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? colors.textOnAccent : colors.textSecondary,
          ),
          textAlign: TextAlign.center,
          child: Text(label, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
