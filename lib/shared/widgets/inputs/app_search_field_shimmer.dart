import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Loading placeholder shown in place of an [AppSearchField].
///
/// Mirrors the real field's box — same 12 px radius, fill and padding — with a
/// skeleton magnify icon and hint bar inside, so the header does not shift when
/// the data lands and the field takes its place.
///
/// Show this only while the **first** page is in flight. A debounced query
/// change keeps the previous page, so the real field must stay on screen and
/// keep the user's keystrokes.
class AppSearchFieldShimmer extends StatelessWidget {
  /// Creates an [AppSearchFieldShimmer].
  const AppSearchFieldShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
        border: Border.all(color: colors.surfaceDefault),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: const Row(
          children: [
            _SkeletonBox(height: 18, width: 18, borderRadius: 9),
            SizedBox(width: 9),
            _SkeletonBox(height: 14, width: 120),
          ],
        ),
      ),
    );
  }
}

/// Rounded placeholder block painted under the shimmer gradient.
class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.height, required this.width, this.borderRadius = 4});

  /// Height of the block in logical pixels.
  final double height;

  /// Width of the block in logical pixels.
  final double width;

  /// Corner radius of the block.
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
