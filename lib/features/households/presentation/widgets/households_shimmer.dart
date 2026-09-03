import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Full-list shimmer placeholder shown while [filteredHouseholdsProvider] loads.
///
/// Mirrors the visual structure of the real list: a header row (count label +
/// sort button) and five [_HouseholdCardSkeleton] cards that exactly match the
/// layout of [HouseholdCard].
class HouseholdsListShimmer extends StatelessWidget {
  /// Creates a [HouseholdsListShimmer].
  const HouseholdsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      children: [
        // Header row: count label + sort button (icon + label) placeholders
        Shimmer.fromColors(
          baseColor: colors.bgPrimary,
          highlightColor: colors.surfaceDefault,
          child: const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerBox(height: 20, width: 130),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ShimmerBox(height: 20, width: 14),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    _ShimmerBox(height: 20, width: 70),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 12),
            itemCount: 5,
            itemBuilder: (_, _) => const _HouseholdCardSkeleton(),
          ),
        ),
      ],
    );
  }
}

/// Skeleton card that mirrors the layout of [HouseholdCard] exactly.
///
/// Reproduces every visual region — name/ID, AUM + YTD row, allocation bar,
/// and the divider + View Details footer — using [_ShimmerBox] placeholders.
class _HouseholdCardSkeleton extends StatelessWidget {
  const _HouseholdCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.surfaceDefault),
      ),
      padding: const EdgeInsets.all(18),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Household name (fontSize 18, lineHeight 28/18 → height 21)
            const _ShimmerBox(height: 21, width: 180),
            const SizedBox(height: 5),
            // ID / account count (fontSize 12)
            const _ShimmerBox(height: 14, width: 130),
            const SizedBox(height: 12),
            // AUM + YTD row — mirrors LayoutBuilder split (55 % / 40 %)
            LayoutBuilder(
              builder: (_, constraints) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: constraints.maxWidth * 0.55,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "TOTAL AUM" label
                        _ShimmerBox(height: 14, width: 80),
                        SizedBox(height: 4),
                        // Large dollar value (fontSize 24, height 28)
                        _ShimmerBox(height: 28),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.40,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Trending icon + value row
                        _ShimmerBox(height: 14),
                        SizedBox(height: 2),
                        // "YTD Change" label
                        _ShimmerBox(height: 12, width: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Allocation label row
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerBox(height: 12, width: 60),
                _ShimmerBox(height: 12, width: 130),
              ],
            ),
            const SizedBox(height: 6),
            // Allocation segmented bar (height: 6, borderRadius: 3)
            const _ShimmerBox(height: 6, borderRadius: 3),
            const SizedBox(height: 16),
            // Divider + "View Details" link
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.borderDefault)),
              ),
              padding: const EdgeInsets.only(top: 10),
              child: const _ShimmerBox(height: 14, width: 80),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rounded rectangle placeholder block used inside shimmer skeletons.
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 4,
  });

  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
