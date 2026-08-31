import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder for the account-type filter chip row (All /
/// Household-linked / Standalone), shown in its place while the list is
/// loading or refreshing.
class AccountsFilterChipsShimmer extends StatelessWidget {
  /// Creates an [AccountsFilterChipsShimmer].
  const AccountsFilterChipsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Shimmer.fromColors(
      baseColor: colors.bgPrimary,
      highlightColor: colors.surfaceDefault,
      child: const Row(
        children: [
          _ShimmerBox(height: 34, width: 46, borderRadius: 9999),
          SizedBox(width: 8),
          _ShimmerBox(height: 34, width: 140, borderRadius: 9999),
          SizedBox(width: 8),
          _ShimmerBox(height: 34, width: 100, borderRadius: 9999),
        ],
      ),
    );
  }
}

/// Full-list shimmer placeholder shown while [filteredAccountsProvider] loads.
///
/// Mirrors the visual structure of the real list: a header row (count label +
/// sort button) and six [_AccountCardSkeleton] cards that exactly match the
/// layout of [AccountCard].
class AccountsListShimmer extends StatelessWidget {
  /// Creates an [AccountsListShimmer].
  const AccountsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row: count label + sort button (icon + label) placeholders.
        // Matches the households list shimmer so both screens load identically.
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
                    SizedBox(width: 5, height: 5),
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
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: 6,
            itemBuilder: (_, i) => _AccountCardSkeleton(isLast: i == 5),
          ),
        ),
      ],
    );
  }
}

/// Skeleton card that mirrors the layout of [AccountCard] exactly.
///
/// Reproduces every visual region — name/value, account number, custodian,
/// risk badge, allocation bar, and the divider + View Details footer — using
/// [_ShimmerBox] placeholders.
class _AccountCardSkeleton extends StatelessWidget {
  const _AccountCardSkeleton({required this.isLast});

  /// Suppresses bottom margin on the last card, matching [AccountCard.isLast].
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
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
            // 3-row info column
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: account name | current value
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _ShimmerBox(height: 18)),
                    SizedBox(width: 8),
                    _ShimmerBox(height: 18, width: 60),
                  ],
                ),
                SizedBox(height: 4),
                // Row 2: account number | YTD trend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _ShimmerBox(height: 14)),
                    SizedBox(width: 8),
                    _ShimmerBox(height: 14, width: 40),
                  ],
                ),
                SizedBox(height: 4),
                // Row 3: custodian line
                _ShimmerBox(height: 14, width: 110),
                SizedBox(height: 6),
                // Row 4: risk badge + account type
                Row(
                  children: [
                    _ShimmerBox(height: 20, width: 56),
                    SizedBox(width: 8),
                    _ShimmerBox(height: 14, width: 80),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
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
              padding: const EdgeInsets.only(top: 17),
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
