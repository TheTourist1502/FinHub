import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Full-screen body shimmer shown while [householdDetailViewProvider] loads.
///
/// Follows the same convention as [AccountsListShimmer] and
/// [HouseholdsListShimmer]: each card keeps its real chrome (background,
/// border, radius, shadow) and only the inner content is replaced by
/// shimmering [_ShimmerBox] placeholders, so nothing shifts once the data
/// arrives.
///
/// Reproduces the structure of [HouseholdDetailScreen]:
///  1. [_TopCardSkeleton] — mirrors [HouseholdsDetailTopCard].
///  2. [_TabBarSkeleton] — three tab placeholders matching the real TabBar.
///  3. The Overview tab's allocation card, Top Accounts card, and Latest
///     Activity card.
class HouseholdDetailShimmer extends StatelessWidget {
  /// Creates a [HouseholdDetailShimmer].
  const HouseholdDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TopCardSkeleton(),
        const _TabBarSkeleton(),
        Expanded(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              const _AllocationCardSkeleton(),
              const SizedBox(height: 16),
              const _TopAccountsCardSkeleton(),
              const SizedBox(height: 24),
              // "Latest Activity" section title
              Shimmer.fromColors(
                baseColor: colors.bgPrimary,
                highlightColor: colors.surfaceDefault,
                child: const _ShimmerBox(height: 18, width: 120),
              ),
              const SizedBox(height: 12),
              const _LatestActivityCardSkeleton(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Skeleton that mirrors [HouseholdsDetailTopCard]'s visual layout.
class _TopCardSkeleton extends StatelessWidget {
  const _TopCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: colors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderDefault),
          boxShadow: [
            BoxShadow(color: colors.cardShadow, blurRadius: 20, spreadRadius: -2, offset: const Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Shimmer.fromColors(
          baseColor: colors.bgPrimary,
          highlightColor: colors.surfaceDefault,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Household name
              _ShimmerBox(height: 21, width: 200),
              SizedBox(height: 4),
              // "Code • N Accounts" subtitle
              _ShimmerBox(height: 16, width: 160),
              SizedBox(height: 12),
              // "Total AUM" eyebrow
              _ShimmerBox(height: 18, width: 80),
              SizedBox(height: 4),
              // Hero value + YTD label
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ShimmerBox(height: 32, width: 180),
                  SizedBox(width: 8),
                  _ShimmerBox(height: 18, width: 36),
                ],
              ),
              SizedBox(height: 8),
              // YTD return pill + performance label
              Row(
                children: [
                  _ShimmerBox(height: 24, width: 120, borderRadius: 12),
                  SizedBox(width: 12),
                  _ShimmerBox(height: 16, width: 100),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton that mirrors the three-tab [TabBar] used on the detail screen,
/// including its bottom divider line.
class _TabBarSkeleton extends StatelessWidget {
  const _TabBarSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderDefault)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: const Row(
          children: [
            Expanded(child: Center(child: _ShimmerBox(height: 14, width: 70))),
            Expanded(child: Center(child: _ShimmerBox(height: 14, width: 70))),
            Expanded(child: Center(child: _ShimmerBox(height: 14, width: 70))),
          ],
        ),
      ),
    );
  }
}

/// Skeleton mirroring [HouseholdsAssetAllocation] — title, donut, and legend.
class _AllocationCardSkeleton extends StatelessWidget {
  const _AllocationCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Asset Allocation" heading
            const _ShimmerBox(height: 20, width: 140),
            const SizedBox(height: 16),
            Row(
              children: [
                // Donut chart
                const _ShimmerBox(height: 128, width: 128, borderRadius: 64),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: List.generate(
                      4,
                      (i) => Padding(
                        padding: EdgeInsets.only(bottom: i == 3 ? 0 : 12),
                        child: const Row(
                          children: [
                            _ShimmerBox(height: 10, width: 10, borderRadius: 5),
                            SizedBox(width: 8),
                            Expanded(child: _ShimmerBox(height: 12)),
                            SizedBox(width: 8),
                            _ShimmerBox(height: 12, width: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Rounding-disclosure footnote — wraps to two lines at card width
            const _ShimmerBox(height: 10),
            const SizedBox(height: 4),
            const _ShimmerBox(height: 10, width: 180),
          ],
        ),
      ),
    );
  }
}

/// Skeleton mirroring the Overview tab's Top Accounts card — section header
/// plus three divider-separated account rows.
class _TopAccountsCardSkeleton extends StatelessWidget {
  const _TopAccountsCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final outline = Theme.of(context).colorScheme.outlineVariant;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: outline),
        boxShadow: [
          BoxShadow(color: colors.cardShadow, blurRadius: 20, spreadRadius: -2, offset: const Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header: "Top Accounts" + "See all (N)"
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: outline)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 21),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ShimmerBox(height: 20, width: 120),
                  _ShimmerBox(height: 18, width: 80),
                ],
              ),
            ),
            // Account rows
            ...List.generate(3, (i) {
              return Column(
                children: [
                  if (i > 0) Divider(height: 1, thickness: 1, color: outline),
                  const _TopAccountRowSkeleton(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for a single row inside the Top Accounts card — name / number /
/// type pill on the left, value / change / label on the right.
class _TopAccountRowSkeleton extends StatelessWidget {
  const _TopAccountRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(height: 16),
                SizedBox(height: 4),
                _ShimmerBox(height: 14, width: 120),
                SizedBox(height: 6),
                _ShimmerBox(height: 20, width: 72, borderRadius: 6),
              ],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _ShimmerBox(height: 17, width: 64),
                SizedBox(height: 4),
                _ShimmerBox(height: 14, width: 50),
                SizedBox(height: 6),
                _ShimmerBox(height: 13, width: 66),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton mirroring the Overview tab's Latest Activity card — badge avatar,
/// title + subtitle, and the trailing amount.
class _LatestActivityCardSkeleton extends StatelessWidget {
  const _LatestActivityCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
        boxShadow: [
          BoxShadow(color: colors.cardShadow, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: const Row(
          children: [
            _ShimmerBox(height: 40, width: 40, borderRadius: 20),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(height: 16, width: 140),
                  SizedBox(height: 4),
                  _ShimmerBox(height: 14, width: 180),
                ],
              ),
            ),
            SizedBox(width: 12),
            _ShimmerBox(height: 16, width: 70),
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
