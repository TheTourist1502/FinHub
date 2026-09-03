import 'dart:ui' show lerpDouble;

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/core/utils/currency_utils.dart';
import 'package:finhub/features/households/domain/models/household_detail.dart';
import 'package:finhub/features/households_detailed_view/presentation/providers/household_detail_view_provider.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:finhub/shared/widgets/charts/asset_allocation_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Card representing a single household in the Households list.
///
/// Matches the Figma design (node 824:1506).  Layout (top → bottom):
/// 1. Household name + ID/account-count row.
/// 2. Total AUM + YTD-return row.
/// 3. Asset-allocation label row + segmented progress bar.
/// 4. Hairline divider + "View Details" link.
class HouseholdCard extends ConsumerWidget {
  /// Creates a [HouseholdCard] for the given [household].
  const HouseholdCard({required this.household, super.key});

  final HouseholdDetail household;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final isPositive = household.aumChangePercentage >= 0;
    final returnColor = isPositive ? colors.chartPositive : colors.chartNegative;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Name + ID ────────────────────────────────────────────────────
            Text(
              household.householdName,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
                height: 28 / 18,
              ),
            ),
            Row(
              children: [
                Text(
                  context.l10n.householdsHouseholdIdLabel(household.householdId),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(Icons.circle, size: 3, color: cs.onSurfaceVariant),
                ),
                Text(
                  context.l10n.householdsTotalAccounts(household.totalAccounts),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── AUM + YTD return ─────────────────────────────────────────────
            LayoutBuilder(
              builder: (context, constraints) {
                // 55 / 45 split of the available row width.
                final aumWidth = constraints.maxWidth * 0.55;
                final changeWidth = constraints.maxWidth * 0.45;

                final aumText = compactDollar(household.totalAum);
                final changeText =
                    '${compactDollar(household.aumChange.abs())} (${household.aumChangePercentage.abs().toStringAsFixed(1)}%)';

                // Step down to the compact style before letting the FittedBox
                // scale, so an overflowing value reads as smaller/lighter text
                // rather than a shrunken heavy one.
                final aumStyle = _fittingStyle(context, aumText, _aumStyle, _aumCompactStyle, aumWidth);
                final changeStyle = _fittingStyle(
                  context,
                  changeText,
                  _changeStyle,
                  _changeCompactStyle,
                  changeWidth - _changeRowLeadingWidth,
                );

                // AUM, change amount and change percentage all roll off one
                // clock so the three land together, and wait for the row to
                // scroll into view. Each starts at [_entranceFraction] of its
                // real figure rather than at zero: the values sit in
                // `FittedBox`es, and a changing digit count would rescale the
                // type on every frame. The styles above are measured from the
                // final text, so they stay fixed throughout the roll.
                return FigureReveal(
                  revealOnScroll: true,
                  duration: AppMotion.settle,
                  builder: (context, t) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // ── Section 1: Total AUM (55%) ────────────────────────────
                      SizedBox(
                        width: aumWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.dashboardTotalAum,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.6,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                compactDollar(
                                  lerpDouble(household.totalAum * _entranceFraction, household.totalAum, t)!,
                                ),
                                maxLines: 1,
                                style: aumStyle.copyWith(color: cs.onSurface),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ── Section 2: YTD change (45%) ───────────────────────────
                      SizedBox(
                        width: changeWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FittedBox(
                              alignment: Alignment.centerRight,
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Iconify(
                                    isPositive ? Mdi.trending_up : Mdi.trending_down,
                                    color: returnColor,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    isPositive ? '+' : '-',
                                    style: changeStyle.copyWith(color: returnColor),
                                  ),
                                  Text(
                                    _changeText(household, t),
                                    maxLines: 1,
                                    style: changeStyle.copyWith(color: returnColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              context.l10n.dashboardYtdChangeLabel,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // ── Asset allocation ──────────────────────────────────────────────
            if (household.assetAllocation.isNotEmpty) ...[
              const SizedBox(height: 16),
              AssetAllocationSection(
                allocations: household.assetAllocation
                    .map(
                      (a) => AssetAllocationEntry(
                        assetClass: a.assetClass,
                        percent: a.allocationPercentage,
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 16),

            // ── Divider + View Details ────────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colors.borderDefault),
                ),
              ),
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  // Fire all 4 detail API calls immediately on tap so data is
                  // already loading before the navigation animation completes.
                  ref.read(householdDetailViewProvider(household.householdId).future).ignore();
                  AppLogger.i('Navigating to detail for household ${household.householdId}');
                  await context.push(
                    AppRoutes.householdsDetailedView.replaceFirst(
                      ':householdId',
                      household.householdId,
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.dashboardViewDetails,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.interactiveDefault,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Iconify(Mdi.arrow_right, color: colors.interactiveDefault, size: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Default style for the Total AUM value.
const _aumStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 24,
  fontWeight: FontWeight.w700,
  letterSpacing: -0.6,
  height: 28 / 24,
);

/// The YTD change amount and percentage at reveal progress [t], formatted as
/// `$1.2M (12.0%)`. Both roll off the same [t], so the pair never disagrees
/// mid-flight about how far along the reveal is.
String _changeText(HouseholdDetail household, double t) {
  final amount = lerpDouble(household.aumChange.abs() * _entranceFraction, household.aumChange.abs(), t)!;
  final percent = lerpDouble(
    household.aumChangePercentage.abs() * _entranceFraction,
    household.aumChangePercentage.abs(),
    t,
  )!;
  return '${compactDollar(amount)} (${percent.toStringAsFixed(1)}%)';
}

/// Fraction of a figure the roll starts from. Close enough to the real value
/// that the digit count — and so the `FittedBox` scale — does not change while
/// it rolls.
const double _entranceFraction = 0.9;

/// Total AUM value style used when [_aumStyle] would not fit the 55% column.
const _aumCompactStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 20,
  fontWeight: FontWeight.w500,
  letterSpacing: -0.4,
  height: 24 / 20,
);

/// Default style for the YTD change amount (e.g. `$1.2M (12%)`).
const _changeStyle = TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600);

/// YTD change amount style used when [_changeStyle] would not fit the 45% column.
const _changeCompactStyle = TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500);

/// Width the trend icon, its gap and the `+`/`-` sign take up ahead of the
/// change amount, subtracted before measuring how much room the amount has.
const _changeRowLeadingWidth = 26.0;

/// Returns [normal] when [text] renders within [maxWidth], otherwise [compact].
///
/// Used to drop to a smaller, lighter style before the surrounding [FittedBox]
/// resorts to scaling the glyphs down.
TextStyle _fittingStyle(
  BuildContext context,
  String text,
  TextStyle normal,
  TextStyle compact,
  double maxWidth,
) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: normal),
    textDirection: Directionality.of(context),
  )..layout();
  return painter.width <= maxWidth ? normal : compact;
}
