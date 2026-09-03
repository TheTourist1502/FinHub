import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder for the All / Trade / Non-Trade chip row
/// (`_TypeFilterChips` in `ViewTransactionScreen`), shown in its place while
/// [viewTransactionsNotifierProvider] is loading or refreshing.
///
/// Mirrors the real row: three pill skeletons at the chip's 34 px height,
/// sized to their labels so the header doesn't shift when the chips arrive.
class ViewTransactionFilterChipsShimmer extends StatelessWidget {
  /// Creates a [ViewTransactionFilterChipsShimmer].
  const ViewTransactionFilterChipsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Shimmer.fromColors(
      baseColor: colors.bgPrimary,
      highlightColor: colors.surfaceDefault,
      child: const Row(
        children: [
          _ShimmerBox(height: 34, width: 128, borderRadius: 9999),
          SizedBox(width: 8),
          _ShimmerBox(height: 34, width: 76, borderRadius: 9999),
          SizedBox(width: 8),
          _ShimmerBox(height: 34, width: 100, borderRadius: 9999),
        ],
      ),
    );
  }
}

/// Shimmer placeholder for the count/sort header row and date-grouped
/// transaction list shown inside `_TransactionHistoryList` while
/// [filteredViewTransactionsProvider] is loading or refreshing.
///
/// Mirrors the real layout: a label + sort-button row (`SortHeaderRow` /
/// `SortMenuButton`) followed by six card skeletons matching
/// [TransactionCard].
class ViewTransactionListShimmer extends StatelessWidget {
  /// Creates a [ViewTransactionListShimmer].
  const ViewTransactionListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          // Header row: count label + sort button (icon + label) placeholders
          Shimmer.fromColors(
            baseColor: colors.bgPrimary,
            highlightColor: colors.surfaceDefault,
            child: const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ShimmerBox(height: 12, width: 100),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ShimmerBox(height: 14, width: 14),
                      SizedBox(width: 6),
                      _ShimmerBox(height: 12, width: 90),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, _) => const _TransactionCardSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton card mirroring [TransactionCard]'s layout: account info +
/// amount row, a divider, a type-badge + price row, and a "View Details" link.
class _TransactionCardSkeleton extends StatelessWidget {
  const _TransactionCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surfaceDefault),
      ),
      padding: const EdgeInsets.all(17),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ShimmerBox(width: 140, height: 10),
                      SizedBox(height: 6),
                      _ShimmerBox(height: 14),
                      SizedBox(height: 4),
                      _ShimmerBox(width: 100, height: 10),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  flex: 35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _ShimmerBox(height: 14),
                      SizedBox(height: 4),
                      _ShimmerBox(width: 50, height: 10),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(height: 1, color: colors.borderDefault),
            ),
            const Row(
              children: [
                _ShimmerBox(width: 44, height: 20, borderRadius: 8),
                Spacer(),
                _ShimmerBox(width: 64, height: 10),
              ],
            ),
            const SizedBox(height: 12),
            const _ShimmerBox(width: 80, height: 12),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(borderRadius)),
    );
  }
}
