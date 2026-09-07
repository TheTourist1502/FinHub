import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/widgets/commission_transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// List-region shimmer shown while [commissionDetailedViewProvider] loads.
///
/// Follows the same convention as [AccountsListShimmer] and
/// [HouseholdsListShimmer]: only the region that depends on the pending fetch
/// is replaced — the header card and search field above it stay real, since
/// their content is already in hand. Each card keeps its real chrome
/// (background, border, radius, shadow) and only the inner content becomes a
/// shimmering [_ShimmerBox], so nothing shifts once the data arrives.
///
/// Reproduces the sort header and a viewport-filling run of
/// [CommissionTransactionCard] skeletons. Every placeholder that stands in for
/// text is sized from that card's own [CommissionTransactionCardStyles] rather
/// than from a copied number, so the skeleton cannot drift out of step with it.
class CommissionTransactionsListShimmer extends StatelessWidget {
  /// Creates a [CommissionTransactionsListShimmer].
  const CommissionTransactionsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "ALL COMMISSIONS" label + sort control, matching SortHeaderRow's
        // fixed height so the real row drops in without a jump.
        const _Shimmer(
          child: SizedBox(
            height: AppDimensions.sortHeaderRowHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerBox(height: 18, width: 140),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ShimmerBox(height: 18, width: 14),
                    SizedBox(width: 5),
                    _ShimmerBox(height: 18, width: 70),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 32),
            itemCount: 4,
            addAutomaticKeepAlives: false,
            itemBuilder: _buildSkeleton,
          ),
        ),
      ],
    );
  }

  /// Top-level builder so the `ListView` gets the same closure every rebuild.
  static Widget _buildSkeleton(BuildContext context, int index) => const _CommissionCardSkeleton();
}

/// Standard shimmer sweep used across the skeleton, so the colour pair is
/// declared once and every wrapped block animates identically.
class _Shimmer extends StatelessWidget {
  const _Shimmer({required this.child});

  /// Placeholder content to sweep.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Shimmer.fromColors(
      baseColor: colors.bgPrimary,
      highlightColor: colors.surfaceDefault,
      child: child,
    );
  }
}

/// Skeleton card that mirrors the layout of [CommissionTransactionCard] — the
/// tinted security header block, the commission-earned block with its bottom
/// divider, and the trade-ID footer.
class _CommissionCardSkeleton extends StatelessWidget {
  const _CommissionCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
        boxShadow: [
          BoxShadow(color: colors.cardShadow, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Security header — keeps the real tinted background ───────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.bgPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            // This block's background is bgPrimary — the base colour used
            // everywhere else — so placeholders inside it would be invisible
            // with the standard pair. surfaceDefault → borderStrong is the
            // inverse: it contrasts against the tint and still visibly sweeps
            // in both light and dark themes.
            child: Shimmer.fromColors(
              baseColor: colors.surfaceDefault,
              highlightColor: colors.borderStrong,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerLine(style: CommissionTransactionCardStyles.name, width: 170),
                  SizedBox(height: 2),
                  _ShimmerLine(style: CommissionTransactionCardStyles.detail, width: 200),
                ],
              ),
            ),
          ),

          // ── Amounts row + bottom divider ─────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 12, bottom: 13),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.borderDefault)),
            ),
            child: const _Shimmer(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Commission earned, leading edge.
                  Expanded(child: _AmountBlockSkeleton(labelWidth: 112, valueWidth: 96)),
                  SizedBox(width: 12),
                  // Transaction amount, trailing edge — end-aligned like the
                  // real block, so the two columns mirror rather than repeat.
                  Expanded(
                    child: _AmountBlockSkeleton(
                      labelWidth: 118,
                      valueWidth: 84,
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Footer: trade ID and trade date ──────────────────────────────
          const _Shimmer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerLine(style: CommissionTransactionCardStyles.footer, width: 150),
                _ShimmerLine(style: CommissionTransactionCardStyles.footer, width: 116),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Label-over-value pair standing in for one `_InfoBlock` of the card's
/// amounts row. Both bars are sized from the real styles, so the block is
/// exactly as tall as the one it replaces.
class _AmountBlockSkeleton extends StatelessWidget {
  const _AmountBlockSkeleton({
    required this.labelWidth,
    required this.valueWidth,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  /// Width of the caption bar.
  final double labelWidth;

  /// Width of the amount bar.
  final double valueWidth;

  /// Matches the alignment of the block being stood in for.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        _ShimmerLine(style: CommissionTransactionCardStyles.amountLabel, width: labelWidth),
        const SizedBox(height: 2),
        _ShimmerLine(style: CommissionTransactionCardStyles.amountValue, width: valueWidth),
      ],
    );
  }
}

/// Rounded shape shared by every placeholder bar.
final BoxDecoration _barShape = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(4),
);

/// A placeholder bar exactly as tall as one rendered line of [style].
///
/// The height comes from laying out a zero-width space in the real style rather
/// than from a copied number. A style with no explicit `height` — like
/// [CommissionTransactionCardStyles.name] — takes its line box from Inter's own
/// metrics, which no constant in this file could track.
class _ShimmerLine extends StatelessWidget {
  const _ShimmerLine({required this.style, required this.width});

  /// The card style whose line height this bar must match.
  final TextStyle style;

  /// Placeholder width.
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        children: [
          // A zero-width space, laid out but never seen: it gives the stack the
          // style's real line box without painting a glyph.
          Text('​', style: style.copyWith(color: AppColors.staticTransparent)),
          Positioned.fill(child: DecoratedBox(decoration: _barShape)),
        ],
      ),
    );
  }
}

/// Rounded rectangle placeholder block of a fixed height, for chrome that is
/// not a line of text.
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.height,
    this.width = double.infinity,
  });

  /// Placeholder height.
  final double height;

  /// Placeholder width; fills the available space by default.
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(width: width, height: height, decoration: _barShape);
  }
}
