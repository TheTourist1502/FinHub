import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:flutter/material.dart';

/// Horizontal row of pill-shaped filter chips — centred.
class HistoryChartFilterChips extends StatelessWidget {
  /// Creates a [HistoryChartFilterChips].
  const HistoryChartFilterChips({
    required this.available,
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final List<DashboardFilter> available;
  final DashboardFilter selected;
  final ValueChanged<DashboardFilter> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: available
          .map(
            (f) => _Chip(
              filter: f,
              isSelected: f == selected,
              onTap: () => onSelect(f),
            ),
          )
          .toList(),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  final DashboardFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.duration(context, AppMotion.quick),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.bgBrandNavyBlue : colors.surfaceDisabled,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.bgOverlay.withAlpha(13),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          filter.label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
            color: isSelected ? colors.textOnAccent : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
