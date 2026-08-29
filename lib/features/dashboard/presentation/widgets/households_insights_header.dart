import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Header row of the households insights section: title plus "View all" link.
///
/// Takes only the household count so it rebuilds independently of the cards.
class HouseholdsInsightsHeader extends StatelessWidget {
  /// Creates a [HouseholdsInsightsHeader].
  const HouseholdsInsightsHeader({required this.householdCount, super.key});

  /// Number of loaded households; below 5 the short title variant is used and
  /// at zero the "View all" link is hidden.
  final int householdCount;

  /// Title text style; color is applied per theme in [build].
  static const TextStyle _titleStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  /// Trailing "by AUM" qualifier style; color is applied per theme in [build].
  static const TextStyle _qualifierStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            text: householdCount < 5 ? l10n.dashboardTopHouseholdsShort : l10n.dashboardTopHouseholds,
            style: _titleStyle.copyWith(color: colors.textPrimary),
            children: [
              TextSpan(
                text: ' ${l10n.dashboardByAum}',
                style: _qualifierStyle.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
        if (householdCount > 0) const _ViewAllLink(),
      ],
    );
  }
}

/// Tappable "View all" label that navigates to the households list.
class _ViewAllLink extends StatelessWidget {
  /// Creates a [_ViewAllLink].
  const _ViewAllLink();

  /// Link label style; color is applied per theme in [build].
  static const TextStyle _labelStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    final accent = context.appColors.interactiveDefault;

    return GestureDetector(
      onTap: () => context.go(AppRoutes.households),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.dashboardViewAll, style: _labelStyle.copyWith(color: accent)),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: accent, size: 14),
        ],
      ),
    );
  }
}
