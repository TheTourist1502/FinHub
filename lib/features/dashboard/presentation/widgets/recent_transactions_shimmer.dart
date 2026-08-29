import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Loading placeholder for the recent-transactions section.
///
/// Block sizes mirror the real title and row typography so the swap in does
/// not shift the dashboard layout.
class RecentTransactionsShimmer extends StatelessWidget {
  /// Creates a [RecentTransactionsShimmer].
  const RecentTransactionsShimmer({super.key});

  /// Number of placeholder rows drawn under the title block.
  static const int _rowCount = 5;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Shimmer.fromColors(
      baseColor: colors.bgPrimary,
      highlightColor: colors.surfaceDefault,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // sectionTitle: Inter 20px × lineHeight 1.3 = 26
          Container(
            height: 26,
            width: 180,
            decoration: BoxDecoration(
              color: colors.surfaceDefault,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: colors.surfaceDefault,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: List.generate(
                _rowCount,
                (_) => _ShimmerRow(color: colors.surfaceDefault),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One placeholder row: avatar circle, two text bars, and an amount bar.
class _ShimmerRow extends StatelessWidget {
  /// Creates a [_ShimmerRow] painted in [color].
  const _ShimmerRow({required this.color});

  /// Fill colour for every placeholder block in the row.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // labelMedium: Inter 14px × lineHeight 1.43 ≈ 20
                Container(height: 20, width: 120, color: color),
                const SizedBox(height: 2),
                // bodySmall: Inter 12px × lineHeight 1.5 = 18
                Container(height: 18, width: 160, color: color),
              ],
            ),
          ),
          // Amount — Inter 14px, ~×1.2 ≈ 17
          Container(height: 17, width: 60, color: color),
        ],
      ),
    );
  }
}
