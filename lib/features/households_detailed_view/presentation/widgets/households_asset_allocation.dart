import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/asset_class_labels.dart';
import 'package:finhub/core/utils/currency_utils.dart';
import 'package:finhub/features/households_detailed_view/domain/models/household_detail_view.dart';
import 'package:finhub/shared/animations/slide_in.dart';
import 'package:finhub/shared/widgets/charts/allocation_chart_footnote.dart';
import 'package:finhub/shared/widgets/charts/allocation_donut_chart.dart';
import 'package:flutter/material.dart';

/// White card containing the household's asset-allocation donut chart and
/// legend.
///
/// Layout: "Asset Allocation" header, then a Row with the 128×128 donut (left)
/// and legend rows (right). Matches Figma node 2254-4680.
///
/// Tapping a donut slice shows that asset class in the centre label; the
/// centre defaults to the highest-allocation asset class otherwise.
class HouseholdsAssetAllocation extends StatefulWidget {
  /// Creates a [HouseholdsAssetAllocation].
  const HouseholdsAssetAllocation({required this.household, super.key});

  /// The loaded household data containing [HouseholdDetailView.assetAllocation].
  final HouseholdDetailView household;

  @override
  State<HouseholdsAssetAllocation> createState() => _HouseholdsAssetAllocationState();
}

class _HouseholdsAssetAllocationState extends State<HouseholdsAssetAllocation> {
  /// Index of the asset class shown in the donut centre.
  ///
  /// `null` until the user taps a slice, in which case the centre falls
  /// back to the highest-allocation asset class.
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final allocations = widget.household.assetAllocation;
    if (allocations.isEmpty) return const SizedBox.shrink();

    final chartColors = [
      colors.chart1,
      colors.chart2,
      colors.chart3,
      colors.chart4,
      colors.chart5,
      colors.chart6,
      colors.chart7,
      colors.chart8,
      colors.chart9,
      colors.chart10,
    ];

    // Index of the highest-allocation asset class, shown in the donut
    // centre by default until the user taps a different slice.
    var primaryIndex = 0;
    for (var i = 1; i < allocations.length; i++) {
      if (allocations[i].allocationPercentage > allocations[primaryIndex].allocationPercentage) {
        primaryIndex = i;
      }
    }
    final selectedIndex = _selectedIndex;
    final highlightedIndex = selectedIndex != null && selectedIndex < allocations.length ? selectedIndex : primaryIndex;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Text(
            l10n.householdDetailAssetAllocation,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              height: 1,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // ── Donut + legend row ─────────────────────────────────────────────
          // Clips the right edge only, so the legend rows enter from off
          // the card while their leftward overshoot stays uncut.
          SlideInClip(
            direction: SlideDirection.left,
            child: Row(
              children: [
                AllocationDonutChart(
                  assetClasses: [for (final a in allocations) a.assetClass],
                  marketValues: [for (final a in allocations) a.marketValue],
                  percentages: [for (final a in allocations) a.allocationPercentage],
                  sliceColors: [for (var i = 0; i < allocations.length; i++) chartColors[i % chartColors.length]],
                  highlightedIndex: highlightedIndex,
                  highlightedRadius: 24,
                  onSliceTap: (i) => setState(() => _selectedIndex = i),
                  dataIdentity: allocations,
                ),
                const SizedBox(width: 24),

                // Legend — rows fly in from the card's right edge and rock
                // to a stop, landing as the donut finishes drawing the ring
                // they label. The leftward overshoot settles into the gap
                // beside the donut rather than across it.
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      allocations.length,
                      (i) => SlideIn(
                        direction: SlideDirection.left,
                        // Offset one step so the legend follows the donut's
                        // sweep rather than racing it.
                        index: i + 1,
                        revealOnScroll: true,
                        child: _LegendRow(
                          allocation: allocations[i],
                          color: chartColors[i % chartColors.length],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Rounding disclosure ───────────────────────────────────────────
          const AllocationChartFootnote(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Legend row
// ---------------------------------------------------------------------------

/// Single row in the asset-allocation legend: dot + name (left) | amount (right).
class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.allocation, required this.color});

  final HouseholdDetailAllocation allocation;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final displayName = assetClassMediumLabel(context.l10n, allocation.assetClass);
    final amount = compactDollar(allocation.marketValue);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodySmall),
          ),
          const SizedBox(width: 8),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              letterSpacing: 0,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
