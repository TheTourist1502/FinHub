import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/asset_class_labels.dart';
import 'package:finhub/core/utils/currency_utils.dart';
import 'package:finhub/features/account_detail_view/domain/models/detailed_account.dart';
import 'package:finhub/shared/animations/slide_in.dart';
import 'package:finhub/shared/widgets/charts/allocation_chart_footnote.dart';
import 'package:finhub/shared/widgets/charts/allocation_donut_chart.dart';
import 'package:flutter/material.dart';

/// Asset allocation section for the account detail screen.
///
/// Renders a donut chart with a centred class label and a legend listing
/// market values per class. Data comes directly from the loaded
/// [DetailedAccount], so no additional async fetch is needed.
///
/// Tapping a donut slice shows that asset class in the centre label; the
/// centre defaults to the highest-allocation asset class otherwise.
class AccountDetailAllocationSection extends StatefulWidget {
  /// Creates an [AccountDetailAllocationSection].
  const AccountDetailAllocationSection({required this.account, super.key});

  /// The loaded account data containing [DetailedAccount.assetAllocation].
  final DetailedAccount account;

  @override
  State<AccountDetailAllocationSection> createState() => _AccountDetailAllocationSectionState();
}

class _AccountDetailAllocationSectionState extends State<AccountDetailAllocationSection> {
  /// Index of the asset class shown in the donut centre.
  ///
  /// `null` until the user taps a slice, in which case the centre falls
  /// back to the highest-allocation asset class.
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final allocations = widget.account.assetAllocation;
    if (allocations.isEmpty) return const SizedBox.shrink();

    final colors = context.appColors;
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
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.accountDetailAssetAllocation,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              height: 1,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Donut + legend row
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
                const SizedBox(width: 20),

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
          const AllocationChartFootnote(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Legend row
// ---------------------------------------------------------------------------

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.allocation, required this.color});

  final AccountAllocationEntry allocation;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final displayName = assetClassMediumLabel(context.l10n, allocation.assetClass);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: Row(
        children: [
          // Coloured dot — 10 px per Figma spec
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          // Asset class abbreviated display name
          Expanded(
            child: Text(displayName, style: AppTypography.bodySmall),
          ),
          // Market value
          Text(
            compactDollar(allocation.marketValue),
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
