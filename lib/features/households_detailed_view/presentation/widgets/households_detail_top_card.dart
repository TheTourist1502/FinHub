import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/utils/currency_utils.dart';
import 'package:finhub/features/households_detailed_view/domain/models/household_detail_view.dart';
import 'package:finhub/shared/widgets/currency/currency_hero_value.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Fixed top card shared by all three tabs on the household detail screen.
///
/// Matches the design of [AccountDetailTopCard] — floating rounded card with
/// 16 px horizontal margins, household name, status badge, code + account count
/// subtitle, total AUM hero value, and YTD performance pill.
class HouseholdsDetailTopCard extends StatelessWidget {
  /// Creates a [HouseholdsDetailTopCard].
  const HouseholdsDetailTopCard({required this.household, super.key});

  /// The loaded household data to display.
  final HouseholdDetailView household;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final isPositive = household.isPositiveReturn;

    final returnAbs = household.aumChange.abs();
    final returnStr =
        '${isPositive ? '+' : '-'}${compactDollar(returnAbs)} '
        '(${isPositive ? '+' : ''}${household.aumChangePercentage.toStringAsFixed(1)}%)';
    final returnColor = isPositive ? colors.statusSuccess : colors.statusError;
    final returnBadgeBg = isPositive ? colors.statusSuccessBg : colors.statusErrorBg;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: colors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderDefault),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 20,
              spreadRadius: -2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Name + status badge ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    household.householdName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      height: 22 / 20,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // ── Code • N Accounts subtitle ──────────────────────────────────
            Text(
              l10n.householdDetailSubtitle(
                household.householdCode,
                household.accountCount,
              ),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            // ── Total AUM eyebrow ───────────────────────────────────────────
            Text(
              l10n.householdDetailTotalAum,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),

            // ── Hero value + USD label ──────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                CurrencyHeroValue(value: household.totalAum),
                const SizedBox(width: 8),
                // Text(
                //   'USD',
                //   style: TextStyle(
                //     fontFamily: 'Inter',
                //     fontSize: 14,
                //     fontWeight: FontWeight.w500,
                //     color: colors.textSecondary,
                //   ),
                // ),
                // const SizedBox(width: 4),
                Text(
                  l10n.accountDetailHeroYtdLabel,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── YTD return pill + label ─────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: returnBadgeBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Iconify(
                        isPositive ? Mdi.trending_up : Mdi.trending_down,
                        color: returnColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        returnStr,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: returnColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.householdDetailYtdPerformance,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
