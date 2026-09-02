import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Full-screen body shimmer shown while [detailedAccountProvider] loads.
///
/// Follows the same convention as [AccountsListShimmer] and
/// [ViewTransactionListShimmer]: each card keeps its real chrome
/// (background, border, radius, shadow) and only the inner content is
/// replaced by shimmering [_ShimmerBox] placeholders, so nothing shifts once
/// the data arrives.
///
/// Reproduces the structure of [AccountDetailScreen]:
///  1. [_TopCardSkeleton] — mirrors [AccountDetailTopCard].
///  2. [_TabBarSkeleton] — three tab placeholders matching the real TabBar.
///  3. The Overview tab's AUM trend card, allocation card, and Latest
///     Activity card.
class AccountDetailShimmer extends StatelessWidget {
  /// Creates an [AccountDetailShimmer].
  const AccountDetailShimmer({super.key});

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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            children: [
              const _AumTrendCardSkeleton(),
              const SizedBox(height: 16),
              const _AllocationCardSkeleton(),
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

/// Skeleton that mirrors [AccountDetailTopCard]'s visual layout — identity
/// info only (name, number, type, custodian); the AUM hero renders inside the
/// Overview tab's own AUM Trend card, not here.
class _TopCardSkeleton extends StatelessWidget {
  const _TopCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        // The parent Column lays its children out with
        // CrossAxisAlignment.start, so without this the card would shrink-wrap
        // its widest placeholder instead of spanning the screen like the real
        // [AccountDetailTopCard] does.
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderDefault),
          boxShadow: [
            BoxShadow(color: colors.cardShadow, offset: const Offset(0, 4), blurRadius: 20, spreadRadius: -2),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Shimmer.fromColors(
          baseColor: colors.bgPrimary,
          highlightColor: colors.surfaceDefault,
          // Stretch so each line's width is a fraction of the real card width
          // rather than a fixed pixel value, keeping the skeleton in
          // proportion on every screen size.
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Account name — 18px bold line.
              _ShimmerLine(height: 22, widthFactor: 0.72),
              SizedBox(height: 4),
              // "Account: XXXX • Individual" identity line — 12px.
              _ShimmerLine(height: 15, widthFactor: 0.58),
              SizedBox(height: 2),
              // "Custodian : …" — 12px.
              _ShimmerLine(height: 15, widthFactor: 0.42),
              SizedBox(height: 4),
              // "Risk Profile:" label followed by the pill badge.
              Row(
                children: [
                  _ShimmerBox(height: 15, width: 76),
                  SizedBox(width: 6),
                  _ShimmerBox(height: 20, width: 152, borderRadius: 6),
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

/// Skeleton mirroring the Overview tab's AUM Trend card — eyebrow, hero
/// value, change row, chart area, and the period filter chip row.
class _AumTrendCardSkeleton extends StatelessWidget {
  const _AumTrendCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
        boxShadow: [
          BoxShadow(color: colors.cardShadow, blurRadius: 8, spreadRadius: -2, offset: const Offset(0, 2)),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "AUM Trend" eyebrow
            _ShimmerBox(height: 18, width: 80),
            SizedBox(height: 6),
            // Hero value
            _ShimmerBox(height: 34, width: 200),
            SizedBox(height: 8),
            // Change row
            _ShimmerBox(height: 20, width: 130),
            SizedBox(height: 16),
            // Chart area
            _ShimmerBox(height: 96, borderRadius: 8),
            SizedBox(height: 16),
            // Period filter chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ShimmerBox(height: 28, width: 52, borderRadius: 20),
                SizedBox(width: 8),
                _ShimmerBox(height: 28, width: 52, borderRadius: 20),
                SizedBox(width: 8),
                _ShimmerBox(height: 28, width: 52, borderRadius: 20),
                SizedBox(width: 8),
                _ShimmerBox(height: 28, width: 52, borderRadius: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton mirroring [AccountDetailAllocationSection] — title, donut, and
/// legend rows.
class _AllocationCardSkeleton extends StatelessWidget {
  const _AllocationCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Asset Allocation" heading
            const _ShimmerBox(height: 20, width: 140),
            const SizedBox(height: 20),
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

/// Left-aligned text-line placeholder whose width is a fraction of the space
/// its parent offers, so the skeleton scales with the screen instead of
/// locking to fixed pixel widths.
///
/// Must be laid out with a tight cross-axis width (e.g. inside a [Column] with
/// [CrossAxisAlignment.stretch]) for [widthFactor] to have anything to
/// measure against.
class _ShimmerLine extends StatelessWidget {
  const _ShimmerLine({required this.height, required this.widthFactor});

  /// Height of the placeholder, matching the real text line's height.
  final double height;

  /// Portion of the available width the placeholder occupies, `0.0`–`1.0`.
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: _ShimmerBox(height: height),
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
