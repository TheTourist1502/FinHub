import 'dart:math';

import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/shared/widgets/charts/history_chart_geometry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The x-axis label band rendered in its own strip *below* the chart canvas.
///
/// Drawn as a widget overlay rather than through fl_chart's `bottomTitles` so
/// labels never share space with the plotted line and can sit at fractional
/// x positions fl_chart's per-tick callback can't express.
class HistoryChartAxisLabels extends StatelessWidget {
  /// Creates a [HistoryChartAxisLabels].
  const HistoryChartAxisLabels({
    required this.geometry,
    required this.colors,
    required this.showWeekAxis,
    required this.pointLabels,
    required this.months,
    required this.clickableMonths,
    this.onMonthTap,
    super.key,
  });

  /// Pixel math for the chart these labels sit under.
  final HistoryChartGeometry geometry;

  /// Theme tokens supplying the label text color.
  final AppColorTokens colors;

  /// Whether to label every plotted point instead of each month bucket.
  final bool showWeekAxis;

  /// One label per plotted point (e.g. `26 Jul`); only read when
  /// [showWeekAxis] is `true`.
  final List<String> pointLabels;

  /// First day of each calendar month to label, oldest first; ignored when
  /// [showWeekAxis]. Months are laid out in uniform slots, so this can name
  /// the selected window's months even when nothing is plotted.
  final List<DateTime> months;

  /// Whether month labels are tappable (the commission chart only).
  final bool clickableMonths;

  /// Called with a bucket's month when its label is tapped.
  final ValueChanged<DateTime>? onMonthTap;

  /// Shared base style for an axis label. Kept as a constant so tilt
  /// measurement lays text out at exactly the size it renders at.
  static const TextStyle labelTextStyle = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 9);

  /// Widest box a per-point date label ("26 Jul") may occupy — fits a two-digit
  /// day plus the longest localized month abbreviation at 9px.
  static const double _datePointLabelWidth = 48;

  /// Widest box a month-name label may occupy ("Sept", with room to spare).
  static const double _monthLabelWidth = 40;

  /// Band height when labels are tilted, covering their rotated bounds.
  static const double _tiltedHeight = 28;

  /// Band height when labels render level.
  static const double _levelHeight = 16;

  /// Vertical gap between the chart canvas above and this band. Shared so an
  /// empty chart lines its labels up with a populated one's.
  static const double gapAboveBand = 8;

  @override
  Widget build(BuildContext context) {
    final tilted = !showWeekAxis && months.isNotEmpty && _needsTilt(context);
    return SizedBox(
      height: tilted ? _tiltedHeight : _levelHeight,
      width: double.infinity,
      child: Stack(children: _labels(tilted: tilted)),
    );
  }

  /// Whether every month label rotates together, Highcharts-style, because the
  /// widest one no longer fits its slot. Measures real rendered width, since
  /// some locales' month abbreviations run longer than English's.
  bool _needsTilt(BuildContext context) {
    final slotWidth = geometry.monthSlotWidth(months.length);
    final painter = TextPainter(textDirection: Directionality.of(context));
    for (final month in months) {
      painter
        ..text = TextSpan(text: DateFormat('MMM').format(month), style: labelTextStyle)
        ..layout();
      if (painter.width > slotWidth) return true;
    }
    return false;
  }

  /// Builds the positioned labels: one per plotted point on the week axis,
  /// otherwise one centered in each month's uniform slot.
  List<Widget> _labels({required bool tilted}) {
    if (showWeekAxis) {
      // Capped to a point's own slot so the outermost labels don't clamp
      // against the chart edges and visually tighten the end gaps.
      final labelWidth = min(_datePointLabelWidth, geometry.pointSlotWidth);
      return [
        for (var i = 0; i < geometry.pointCount && i < pointLabels.length; i++)
          _positioned(
            centerX: geometry.pointX(i.toDouble()),
            labelWidth: labelWidth,
            text: pointLabels[i],
          ),
      ];
    }

    if (months.isEmpty) return const [];

    final labelWidth = min(_monthLabelWidth, geometry.monthSlotWidth(months.length));
    return [
      for (final (i, month) in months.indexed)
        _positioned(
          centerX: geometry.monthCenterX(i, months.length),
          labelWidth: labelWidth,
          text: DateFormat('MMM').format(month),
          tilted: tilted,
          onTap: clickableMonths ? () => onMonthTap?.call(month) : null,
        ),
    ];
  }

  /// Places one label box of [labelWidth] centered on [centerX] within the band.
  Widget _positioned({
    required double centerX,
    required double labelWidth,
    required String text,
    bool tilted = false,
    VoidCallback? onTap,
  }) {
    return Positioned(
      left: geometry.labelLeft(centerX, labelWidth),
      top: 0,
      bottom: 0,
      width: labelWidth,
      child: Center(
        child: HistoryChartAxisLabel(text: text, colors: colors, tilted: tilted, onTap: onTap),
      ),
    );
  }
}

/// A single x-axis label. Tappable labels render underlined in the brand blue;
/// plain ones use the secondary text token.
class HistoryChartAxisLabel extends StatelessWidget {
  /// Creates a [HistoryChartAxisLabel].
  const HistoryChartAxisLabel({
    required this.text,
    required this.colors,
    this.tilted = false,
    this.onTap,
    super.key,
  });

  /// The label's rendered text.
  final String text;

  /// Theme tokens supplying the non-interactive text color.
  final AppColorTokens colors;

  /// Whether the label is rotated -45°, matching the band's tilt decision.
  final bool tilted;

  /// Tap handler; `null` renders the label non-interactive.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isClickable = onTap != null;
    Widget child = Text(
      text,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.visible,
      style: HistoryChartAxisLabels.labelTextStyle.copyWith(
        fontWeight: isClickable ? FontWeight.w600 : FontWeight.w500,
        color: isClickable ? AppColors.brandFinHubBlue : colors.textSecondary,
        decoration: isClickable ? TextDecoration.underline : TextDecoration.none,
        decorationColor: isClickable ? AppColors.brandFinHubBlue : null,
      ),
    );

    if (tilted) child = Transform.rotate(angle: -pi / 4, child: child);

    return isClickable ? GestureDetector(onTap: onTap, child: child) : child;
  }
}
