import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Full-body shimmer shown while [myCommissionsProvider] loads.
///
/// Follows the same convention as [AccountsListShimmer] and
/// [HouseholdsListShimmer]: every surface keeps its real chrome (background,
/// border, radius, shadow) and only the inner content is replaced by
/// shimmering [_ShimmerBox] placeholders, so nothing shifts once the data
/// arrives.
///
/// Reproduces the loaded screen: the full-bleed [CommissionTrendTopCard], the
/// Overview/Details tab bar, and the overview tab's KPI tiles and top-account
/// rows — the tab the screen opens on.
class MyCommissionsShimmer extends StatelessWidget {
  /// Creates a [MyCommissionsShimmer].
  const MyCommissionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    // Mirrors the loaded body: a fixed trend card and tab bar above a tab
    // content area that takes the remaining height, so the skeleton is
    // exactly as tall as the screen and nothing shifts when data lands.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TrendCardSkeleton(),
        const SizedBox(height: 8),
        // ── Tab bar — keeps the real bottom border ──────────────────────
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colors.borderStrong)),
          ),
          child: Shimmer.fromColors(
            baseColor: colors.bgPrimary,
            highlightColor: colors.surfaceDefault,
            child: const SizedBox(
              // Matches Flutter's text-only TabBar height.
              height: 46,
              child: Row(
                children: [
                  // "Overview" / "Details" — 14 px labels
                  Expanded(child: Center(child: _ShimmerBox(height: 20, width: 68))),
                  Expanded(child: Center(child: _ShimmerBox(height: 20, width: 52))),
                ],
              ),
            ),
          ),
        ),
        // ── Overview tab content — fills the remaining height ────────────
        Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(child: _MetricCardSkeleton()),
                    SizedBox(width: 12),
                    Expanded(child: _MetricCardSkeleton()),
                  ],
                ),
                const SizedBox(height: 16),
                // "Top 5 Accounts" heading — 16 px / 24 line height
                Shimmer.fromColors(
                  baseColor: colors.bgPrimary,
                  highlightColor: colors.surfaceDefault,
                  child: const _ShimmerBox(height: 24, width: 150),
                ),
                const SizedBox(height: 12),
                ...List.generate(3, (_) => const _TopAccountRowSkeleton()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Shimmer for the Details tab's transaction list, shown while
/// [commissionsDetailsNotifierProvider] loads its first page.
///
/// Covers only the list — the search field above it stays real, since it owns
/// its own controller and never waits on the fetch.
class CommissionsDetailsListShimmer extends StatelessWidget {
  /// Creates a [CommissionsDetailsListShimmer].
  const CommissionsDetailsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, _) => const _SummaryCardSkeleton(),
    );
  }
}

/// Skeleton mirroring [CommissionTrendTopCard] — a full-bleed surface with
/// bottom-only rounded corners, the hero value row, and the trend chart with
/// its filter chips and footnote.
class _TrendCardSkeleton extends StatelessWidget {
  const _TrendCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero value + "YTD" label
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // CurrencyHeroValue — 28 px / 40 line height
                _ShimmerBox(height: 40, width: 200),
                SizedBox(width: 4),
                // "YTD" — 14 px
                _ShimmerBox(height: 17, width: 30),
              ],
            ),
            SizedBox(height: 4),
            // Change row — "{amount} • {filter}" segments
            Row(
              children: [
                _ShimmerBox(height: 20, width: 76),
                SizedBox(width: 6),
                _ShimmerBox(height: 17, width: 8),
                SizedBox(width: 6),
                _ShimmerBox(height: 17, width: 34),
              ],
            ),
            SizedBox(height: 12),
            // Chart canvas — matches HistoryChartSection's height: 80
            _ShimmerBox(height: 80, borderRadius: 8),
            SizedBox(height: 12),
            // Range filter chips — 4 pills, 4 px margin each side
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ShimmerBox(height: 27, width: 60, borderRadius: 9999),
                SizedBox(width: 8),
                _ShimmerBox(height: 27, width: 60, borderRadius: 9999),
                SizedBox(width: 8),
                _ShimmerBox(height: 27, width: 60, borderRadius: 9999),
                SizedBox(width: 8),
                _ShimmerBox(height: 27, width: 60, borderRadius: 9999),
              ],
            ),
            SizedBox(height: 10),
            // "Data as of …" footnote — 10 px text
            _ShimmerBox(height: 13, width: 200),
          ],
        ),
      ),
    );
  }
}

/// Skeleton mirroring [MyCommissionMetricCard] — icon badge, count, and the
/// label/sublabel pair.
class _MetricCardSkeleton extends StatelessWidget {
  const _MetricCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ShimmerBox(height: 40, width: 40, borderRadius: 20),
            SizedBox(height: 8),
            _ShimmerBox(height: 28, width: 40),
            SizedBox(height: 2),
            _ShimmerBox(height: 16, width: 90),
            _ShimmerBox(height: 15, width: 70),
          ],
        ),
      ),
    );
  }
}

/// Skeleton mirroring [TopAccountsCard] — name/commission row above the
/// account-number/label row.
class _TopAccountRowSkeleton extends StatelessWidget {
  const _TopAccountRowSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
        boxShadow: [
          BoxShadow(color: colors.cardShadow, blurRadius: 1, offset: const Offset(0, 1)),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: account name (65 %) | total commission (35 %)
            Row(
              children: [
                Expanded(flex: 65, child: _ShimmerBox(height: 20)),
                SizedBox(width: 8),
                Expanded(flex: 35, child: _ShimmerBox(height: 24)),
              ],
            ),
            SizedBox(height: 4),
            // Row 2: masked account number | "TOTAL COMMISSION" label
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerBox(height: 14, width: 120),
                _ShimmerBox(height: 15, width: 100),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton mirroring [CommissionSummaryCard] — the uppercase account-holder
/// line, the commission-earned block with its bottom divider, and the
/// account-number/View Details footer.
class _SummaryCardSkeleton extends StatelessWidget {
  const _SummaryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account holder name — 10 px uppercase
            const _ShimmerBox(height: 13, width: 160),
            const SizedBox(height: 12),
            // Commission earned block + real bottom divider
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 13),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colors.borderStrong)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Commission earned" label — 10 px
                  _ShimmerBox(height: 13, width: 120),
                  SizedBox(height: 2),
                  // Amount — 18 px / 28 line height
                  _ShimmerBox(height: 28, width: 150),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Footer: account number | View Details
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerBox(height: 16, width: 130),
                _ShimmerBox(height: 16, width: 90),
              ],
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
