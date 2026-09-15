import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/profile/presentation/widgets/preference_selection_option.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Height of one [PreferenceSelectionOption] row.
const _kRadioRowHeight = 66.0;

/// Height of one [PreferenceMultiSelectionOption] row.
const _kMultiRowHeight = 48.0;

/// Widths cycled through the name placeholders so the skeleton list reads as
/// varied entries rather than a block of identical bars.
const _kNameWidthFactors = [0.62, 0.45, 0.78, 0.54, 0.7, 0.4];

/// Shimmer placeholder shown in place of a preference sheet's option list
/// while [countriesProvider] / [regionsProvider] resolve.
///
/// Occupies the same height the loaded list settles at, so the sheet opens at
/// its final size instead of growing underneath the user when the options
/// arrive.
class PreferenceSheetShimmer extends StatelessWidget {
  /// Creates a [PreferenceSheetShimmer].
  ///
  /// [showCodeBadge] picks the row shape: `true` mirrors the radio + code
  /// rows of the country sheet, `false` the checkbox-only rows of the region
  /// sheet.
  const PreferenceSheetShimmer({required this.showCodeBadge, required this.listPadding, super.key});

  /// Whether to draw the 40px code-badge placeholder next to the control.
  final bool showCodeBadge;

  /// Padding of the real list this stands in for, so the skeleton rows line
  /// up with the rows that replace them.
  final EdgeInsets listPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final height = MediaQuery.of(context).size.height * kPreferenceSheetListHeightFactor;
    final rowHeight = showCodeBadge ? _kRadioRowHeight : _kMultiRowHeight;
    final rowCount = (height / (rowHeight + kPreferenceSheetSeparatorHeight)).ceil() + 1;

    return SizedBox(
      height: height,
      child: Shimmer.fromColors(
        baseColor: colors.bgPrimary,
        highlightColor: colors.surfaceDefault,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: listPadding,
          itemCount: rowCount,
          separatorBuilder: (_, _) => const PreferenceSheetSeparator(),
          itemBuilder: (_, i) =>
              _OptionSkeleton(showCodeBadge: showCodeBadge, nameWidthFactor: _kNameWidthFactors[i % _kNameWidthFactors.length]),
        ),
      ),
    );
  }
}

/// One skeleton row, laid out to the same metrics as the option widget it
/// stands in for.
class _OptionSkeleton extends StatelessWidget {
  const _OptionSkeleton({required this.showCodeBadge, required this.nameWidthFactor});

  final bool showCodeBadge;

  /// Fraction of the remaining row width the name placeholder fills.
  final double nameWidthFactor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
      child: Row(
        children: [
          _ShimmerBox(width: showCodeBadge ? 24 : 22, height: showCodeBadge ? 24 : 22, borderRadius: showCodeBadge ? 12 : 6),
          const SizedBox(width: 16),
          if (showCodeBadge) ...[const _ShimmerBox(width: 40, height: 40, borderRadius: 12), const SizedBox(width: 16)],
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(widthFactor: nameWidthFactor, child: const _ShimmerBox(height: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded rectangle placeholder block used inside the skeleton rows.
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.height, this.width = double.infinity, this.borderRadius = 4});

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
