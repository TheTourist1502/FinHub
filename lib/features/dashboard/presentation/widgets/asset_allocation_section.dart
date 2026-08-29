import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/asset_class_labels.dart';
import 'package:finhub/core/utils/currency_utils.dart';
import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:finhub/shared/animations/slide_in.dart';
import 'package:finhub/shared/widgets/charts/allocation_chart_footnote.dart';
import 'package:finhub/shared/widgets/charts/allocation_donut_chart.dart';
import 'package:finhub/shared/widgets/feedback/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

/// Dashboard section showing a donut chart of asset allocation with a
/// right-side legend displaying market values.
///
/// Loads data via [faAllocationsProvider].
class AssetAllocationSection extends ConsumerWidget {
  /// Creates an [AssetAllocationSection].
  const AssetAllocationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(faAllocationsProvider);

    // Crossfades the skeleton out as the data arrives instead of cutting to
    // it — the donut then plays its own reveal sweep underneath the fade.
    return AnimatedSwitcher(
      duration: AppMotion.duration(context, AppMotion.base),
      child: asyncData.when(
        skipLoadingOnRefresh: false,
        loading: () => const _AllocationShimmer(),
        error: (e, _) => const ErrorView(error: UnknownError()),
        data: (allocations) => _AllocationContent(allocations: allocations),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content
// ---------------------------------------------------------------------------

class _AllocationContent extends ConsumerWidget {
  const _AllocationContent({required this.allocations});
  final List<AssetAllocation> allocations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final selectedIndex = ref.watch(assetAllocationSelectedIndexProvider);
    final highlightedIndex = selectedIndex != null && selectedIndex < allocations.length ? selectedIndex : primaryIndex;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 12, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row — title + "View Details" (no chevron per Figma spec)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.dashboardAssetAllocation,
                style: AppTypography.cardTitle.copyWith(fontSize: 16, height: 1, fontWeight: FontWeight.w700),
              ),
              // GestureDetector(
              //   onTap: () {
              //   },
              //   child: Text(
              //     context.l10n.dashboardViewDetails,
              //     style: AppTypography.bodySmall.copyWith(
              //       color: colors.interactiveDefault,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 20),
          // Donut + legend — 128 px donut, right-aligned legend
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
                  highlightedRadius: 26,
                  onSliceTap: (i) => ref.read(assetAllocationSelectedIndexProvider.notifier).select(i),
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
  final AssetAllocation allocation;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final displayName = assetClassMediumLabel(context.l10n, allocation.assetClass);
    final value = compactDollar(allocation.marketValue);

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
            child: Text(
              displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall,
            ),
          ),
          const SizedBox(width: 8),
          // Market value
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: colors.textPrimary,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer
// ---------------------------------------------------------------------------

class _AllocationShimmer extends StatelessWidget {
  const _AllocationShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Shimmer.fromColors(
      baseColor: colors.bgPrimary,
      highlightColor: colors.surfaceDefault,
      child: Container(
        height: 206,
        decoration: BoxDecoration(
          color: colors.surfaceDefault,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
