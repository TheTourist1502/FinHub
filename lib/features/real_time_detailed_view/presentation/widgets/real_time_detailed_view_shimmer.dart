import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Full-screen shimmer placeholder shown while the account/positions/
/// transactions requests load for the first time.
///
/// Follows the same convention as the households and accounts shimmers: every
/// container keeps its real chrome (background, border, radius, padding) and
/// only its inner content is replaced by [_ShimmerBox] placeholders wrapped in
/// [Shimmer.fromColors]. The layout mirrors the loaded screen region for
/// region — account header card, pill tab switcher, search field, delay
/// notice, sort header, and a run of position cards — so nothing shifts when
/// the real data arrives.
class RealTimeDetailedViewShimmer extends StatelessWidget {
  /// Creates a [RealTimeDetailedViewShimmer].
  const RealTimeDetailedViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // ── Account header card ──────────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: _AccountSelectionCardSkeleton(),
        ),
        SizedBox(height: 16),

        // ── Pill tab switcher ────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _PillTabBarSkeleton(),
        ),
        SizedBox(height: 16),

        // ── Tab content ──────────────────────────────────────────────────
        Expanded(child: RealTimeTabContentShimmer()),
      ],
    );
  }
}

/// Shimmer for a single tab's content — search field, notice, sort header, and
/// a run of cards — shown while that tab's own request is still in flight
/// while the other tab already has data.
class RealTimeTabContentShimmer extends StatelessWidget {
  /// Creates a [RealTimeTabContentShimmer].
  const RealTimeTabContentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SearchFieldSkeleton(),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: _AsOfNoticeSkeleton(),
          ),
          const SizedBox(height: 16),
          const _SortHeaderSkeleton(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 32),
              itemCount: 3,
              itemBuilder: (_, i) => Padding(
                padding: EdgeInsets.only(bottom: i == 2 ? 0 : 16),
                child: const _CardShimmer(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer placeholder for a run of position/activity cards, shown in place
/// of the real cards in `RealTimePositionsTab` / `RealTimeTransactionsTab`
/// while a pull-to-refresh is in flight.
///
/// A bare, self-sizing [Column] (wrapped in an inert [SingleChildScrollView]
/// rather than a [ListView]) so it drops safely into either embedding: as a
/// plain item inside an already-scrolling `ListView`, or as the direct child
/// of a `RefreshIndicator` inside an `Expanded`.
class RealTimeCardListShimmer extends StatelessWidget {
  /// Creates a [RealTimeCardListShimmer] with [count] card skeletons.
  const RealTimeCardListShimmer({this.count = 3, super.key});

  /// Number of card skeletons to render.
  final int count;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: List.generate(
          count,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: i == count - 1 ? 0 : 16),
            child: const _CardShimmer(),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Region skeletons
// ---------------------------------------------------------------------------

/// Skeleton mirroring [RealTimeAccountSelectionCard]: keeps the real blue fill,
/// border, radius, and padding, and shimmers only the avatar, name/subtitle
/// lines, and the circular swap button.
class _AccountSelectionCardSkeleton extends StatelessWidget {
  const _AccountSelectionCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        border: Border.all(color: AppColors.blue200),
        borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
      ),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: const Row(
          children: [
            // Initials avatar
            _ShimmerBox(height: 36, width: 36, borderRadius: 18),
            SizedBox(width: 8),
            // Account name over "type • number"
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ShimmerBox(height: 16, width: 140),
                  SizedBox(height: 2),
                  _ShimmerBox(height: 15, width: 170),
                ],
              ),
            ),
            SizedBox(width: 8),
            // Circular swap button
            _ShimmerBox(height: 30, width: 30, borderRadius: 15),
          ],
        ),
      ),
    );
  }
}

/// Skeleton mirroring the pill tab switcher: keeps the real outer surface,
/// border, radius, and 5 px inset, and shimmers the two tab pills inside it.
class _PillTabBarSkeleton extends StatelessWidget {
  const _PillTabBarSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        border: Border.all(color: colors.borderDefault),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: const Row(
          children: [
            Expanded(child: _ShimmerBox(height: 34, borderRadius: 8)),
            SizedBox(width: 8),
            Expanded(child: _ShimmerBox(height: 34, borderRadius: 8)),
          ],
        ),
      ),
    );
  }
}

/// Skeleton mirroring the positions search field: keeps the real filled
/// surface, border, radius, and 42 px height, and shimmers the leading icon
/// and hint text.
class _SearchFieldSkeleton extends StatelessWidget {
  const _SearchFieldSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        border: Border.all(color: colors.borderDefault),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: const Row(
          children: [
            _ShimmerBox(height: 18, width: 18, borderRadius: 9),
            SizedBox(width: 12),
            _ShimmerBox(height: 14, width: 140),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the "prices as of …" notice row (info icon + one line).
class _AsOfNoticeSkeleton extends StatelessWidget {
  const _AsOfNoticeSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Shimmer.fromColors(
      baseColor: colors.bgPrimary,
      highlightColor: colors.surfaceDefault,
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBox(height: 20, width: 20, borderRadius: 10),
          SizedBox(width: 8),
          _ShimmerBox(height: 17, width: 220),
        ],
      ),
    );
  }
}

/// Skeleton for the "ALL HOLDINGS (n)" header row and its sort control,
/// held at the shared [AppDimensions.sortHeaderRowHeight] so the real header
/// drops in without a jump.
class _SortHeaderSkeleton extends StatelessWidget {
  const _SortHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox(
      height: AppDimensions.sortHeaderRowHeight,
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ShimmerBox(height: 16, width: 140),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ShimmerBox(height: 20, width: 14),
                SizedBox(width: 5),
                _ShimmerBox(height: 20, width: 70),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton card that mirrors the layout of [RealTimePositionsCard] exactly.
///
/// Keeps the real card fill, border, radius, shadow, and padding — only the
/// content is shimmered: CUSIP line, avatar + identity + price row above the
/// hairline, and the two footer metrics split by the vertical rule.
class _CardShimmer extends StatelessWidget {
  const _CardShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.bgCard,
        border: Border.all(color: colors.borderDefault),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: colors.cardShadow, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            // CUSIP identifier line
            const _ShimmerBox(height: 12, width: 140),
            // Identity + daily-change row above the hairline
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colors.borderDefault)),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerBox(height: 17, width: 60),
                        SizedBox(height: 2),
                        _ShimmerBox(height: 15, width: 130),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _ShimmerBox(height: 17, width: 60),
                      SizedBox(height: 2),
                      _ShimmerBox(height: 15, width: 50),
                    ],
                  ),
                ],
              ),
            ),
            // Footer: market price / close price metrics split by a rule
            const Row(
              children: [
                _FooterMetricSkeleton(),
                SizedBox(width: 24),
                _ShimmerBox(height: 24, width: 1, borderRadius: 0),
                SizedBox(width: 24),
                _FooterMetricSkeleton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Label-over-value placeholder pair used by the card footer.
class _FooterMetricSkeleton extends StatelessWidget {
  const _FooterMetricSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShimmerBox(height: 12, width: 70),
        SizedBox(height: 2),
        _ShimmerBox(height: 14, width: 55),
      ],
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
