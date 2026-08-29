import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/dashboard/presentation/widgets/households_insights_card.dart';
import 'package:finhub/features/dashboard/presentation/widgets/households_insights_empty_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Loading placeholder mirroring the header row and three household cards.
class HouseholdsInsightsShimmer extends StatelessWidget {
  /// Creates a [HouseholdsInsightsShimmer].
  const HouseholdsInsightsShimmer({super.key});

  /// Number of placeholder cards rendered while loading.
  static const int _placeholderCount = 3;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cardWidth = MediaQuery.sizeOf(context).width * kHouseholdsInsightsCardWidthFactor;

    return Shimmer.fromColors(
      baseColor: colors.bgPrimary,
      highlightColor: colors.surfaceDefault,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerBlock(height: 22, width: 140, radius: 4),
              _ShimmerBlock(height: 15, width: 56, radius: 4),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: [
                for (var i = 0; i < _placeholderCount; i++) ...[
                  if (i > 0) const SizedBox(width: 16),
                  _ShimmerBlock(height: kHouseholdsInsightsCardHeight, width: cardWidth, radius: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded solid block used as a single shimmer placeholder.
class _ShimmerBlock extends StatelessWidget {
  /// Creates a [_ShimmerBlock].
  const _ShimmerBlock({required this.height, required this.width, required this.radius});

  /// Placeholder height in logical pixels.
  final double height;

  /// Placeholder width in logical pixels.
  final double width;

  /// Corner radius of the placeholder.
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: context.appColors.surfaceDefault,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
