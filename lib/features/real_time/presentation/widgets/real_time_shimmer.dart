import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Body shimmer shown on `RealTimeScreen` while
/// `realTimeAccountsNotifierProvider` loads the selectable account list.
///
/// Follows the same convention as the accounts and households shimmers: the
/// input keeps its real chrome (background, border, radius) and only the
/// inner content is replaced by shimmering [_ShimmerBox] placeholders, so
/// nothing shifts once the accounts arrive.
///
/// Mirrors the loaded layout: heading, subtitle, the account picker's label
/// and field, and the Continue button.
class RealTimeShimmer extends StatelessWidget {
  /// Creates a [RealTimeShimmer].
  const RealTimeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Heading section ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Shimmer.fromColors(
              baseColor: colors.bgPrimary,
              highlightColor: colors.surfaceDefault,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  // Title — Inter 30px/1.25, wraps to two lines.
                  _TextLineShimmer(fontSize: 30, lineHeight: 1.25, width: 240),
                  _TextLineShimmer(fontSize: 30, lineHeight: 1.25, width: 170),
                  SizedBox(height: 8),
                  // Subtitle — Inter 14px/1.625, wraps to four lines.
                  _TextLineShimmer(fontSize: 14, lineHeight: 1.625),
                  _TextLineShimmer(fontSize: 14, lineHeight: 1.625),
                  _TextLineShimmer(fontSize: 14, lineHeight: 1.625),
                  _TextLineShimmer(fontSize: 14, lineHeight: 1.625, width: 200),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Account picker label + field ────────────────────────
                Shimmer.fromColors(
                  baseColor: colors.bgPrimary,
                  highlightColor: colors.surfaceDefault,
                  // Field label — AppTypography.formLabel, Inter 14px/1.4.
                  child: const _TextLineShimmer(fontSize: 14, lineHeight: 1.4, width: 150),
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                const _DropdownSkeleton(),
                const SizedBox(height: 32),

                // ── Continue button ────────────────────────────────────
                Shimmer.fromColors(
                  baseColor: colors.bgPrimary,
                  highlightColor: colors.surfaceDefault,
                  child: const _ShimmerBox(height: 46, borderRadius: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder bar for a single line of text set at [fontSize]/[lineHeight].
///
/// The [SizedBox] wrapper reserves the real line's full height so multiple
/// lines stack with the same vertical rhythm as the text they stand in for;
/// the visible bar inside is sized to roughly a glyph's ink height.
class _TextLineShimmer extends StatelessWidget {
  const _TextLineShimmer({
    required this.fontSize,
    this.lineHeight = 1.2,
    this.width = double.infinity,
  });

  /// Font size of the real text line this bar approximates.
  final double fontSize;

  /// Line-height multiplier of the real text line, used to size the reserved
  /// vertical space so stacked lines match real text spacing.
  final double lineHeight;

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fontSize * lineHeight,
      child: Align(
        alignment: Alignment.centerLeft,
        child: _ShimmerBox(height: fontSize * 0.6, width: width),
      ),
    );
  }
}

/// Skeleton for the `AppSingleSelect` trigger field, matching the one used by
/// other picker shimmers in the app.
///
/// The outer box reuses the real field's fill, border, radius and 52px height
/// so it reads as the actual (not-yet-interactive) input rather than a
/// shimmering blob; only the hint and chevron placeholders inside it shimmer.
class _DropdownSkeleton extends StatelessWidget {
  const _DropdownSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Shimmer.fromColors(
        baseColor: colors.surfaceSunken,
        highlightColor: colors.surfaceDefault,
        child: const Row(
          children: [
            _ShimmerBox(height: 14, width: 120),
            Spacer(),
            _ShimmerBox(height: 20, width: 20, borderRadius: 6),
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
