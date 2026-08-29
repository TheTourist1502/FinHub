import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/shared/widgets/sort/sort_menu_button.dart';
import 'package:flutter/material.dart';

/// A responsive header row that pairs a section label with an optional
/// [SortMenuButton].
///
/// Defaults to the shared [AppDimensions.sortHeaderRowHeight] /
/// [AppDimensions.sortHeaderLabelFlex] / [AppDimensions.sortHeaderSortFlex]
/// values so every screen renders this row identically, but [height],
/// [labelFlex], [sortFlex], and [labelStyle] can be overridden for a screen
/// that genuinely needs to deviate from the shared style.
///
/// The two sides are separated by [AppDimensions.sortHeaderRowSpacing]; a row
/// without a [sortMenuButton] renders the label alone with no trailing gap.
///
/// Fits each side into the row height with a [FittedBox], shrinking content
/// that would otherwise overflow instead of wrapping or clipping it. This
/// keeps the row legible across the full range of device widths without
/// per-screen tuning. Renders with no background, border, or border radius.
class SortHeaderRow extends StatelessWidget {
  /// Creates a [SortHeaderRow].
  const SortHeaderRow({
    required this.label,
    this.sortMenuButton,
    this.height = AppDimensions.sortHeaderRowHeight,
    this.labelFlex = AppDimensions.sortHeaderLabelFlex,
    this.sortFlex = AppDimensions.sortHeaderSortFlex,
    this.labelStyle,
    super.key,
  });

  /// Section label, already formatted (e.g. uppercased) by the caller.
  final String label;

  /// Sort control shown at the trailing edge; omit to hide it entirely.
  final SortMenuButton? sortMenuButton;

  /// Row height; defaults to [AppDimensions.sortHeaderRowHeight].
  final double height;

  /// Flex weight for the [label] side of the row.
  final int labelFlex;

  /// Flex weight for the [sortMenuButton] side of the row.
  final int sortFlex;

  /// Overrides the label's default style ([SortMenuButton.rowLabelStyle]).
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        spacing: AppDimensions.sortHeaderRowSpacing,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: labelFlex,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(label, style: labelStyle ?? SortMenuButton.rowLabelStyle(context)),
            ),
          ),
          if (sortMenuButton != null)
            Expanded(
              flex: sortFlex,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: sortMenuButton,
              ),
            ),
        ],
      ),
    );
  }
}
