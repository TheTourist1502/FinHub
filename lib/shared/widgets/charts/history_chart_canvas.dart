import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/widgets/charts/history_chart_axis_labels.dart';
import 'package:finhub/shared/widgets/charts/history_chart_geometry.dart';
import 'package:finhub/shared/widgets/charts/history_chart_touch_layer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// The interactive area line chart stacked above its own month/week axis-label
/// band, sized from the width its parent gives it.
///
/// Touch state lives in [HistoryChartTouchLayer], so touching a point repaints
/// only the chart layer — not the label band, nor the surrounding section's
/// hero value, change row and filter chips.
///
/// Callers should key this widget on whatever determines the plotted dataset
/// (filter, drilled-into month, the data itself) so a dataset change remounts
/// it. The remount both drops a stale touched index and replays the reveal
/// animation that grows the line up from [minY].
class HistoryChartCanvas extends StatelessWidget {
  /// Creates a [HistoryChartCanvas].
  const HistoryChartCanvas({
    required this.spots,
    required this.minY,
    required this.maxY,
    required this.colors,
    required this.isPositive,
    required this.pointCount,
    required this.showWeekAxis,
    required this.pointLabels,
    required this.months,
    required this.clickableMonths,
    required this.showTooltip,
    required this.tooltipText,
    this.onMonthTap,
    this.onTouchedIndexChanged,
    this.height = 96,
    super.key,
  });

  /// The plotted line's data points.
  final List<FlSpot> spots;

  /// Lower bound of the plotted y scale, and the reveal animation's floor.
  final double minY;

  /// Upper bound of the plotted y scale.
  final double maxY;

  /// Theme tokens for the line, fill, labels and tooltip.
  final AppColorTokens colors;

  /// Whether the series trends up, selecting the positive color pair.
  final bool isPositive;

  /// The line chart's rendered height, in logical pixels. Also anchors the
  /// floating tooltip so it always sits just above the chart. Defaults to 96.
  final double height;

  /// The number of points currently plotted — guards the touched index against
  /// a stale value if this changes without the widget remounting.
  final int pointCount;

  /// Whether to render a per-point label from [pointLabels] instead of centered
  /// month-name labels.
  final bool showWeekAxis;

  /// One x-axis label per plotted point (e.g. `26 Jul`), in [spots] order. Only
  /// read when [showWeekAxis] is `true`, and must then have [pointCount] entries.
  final List<String> pointLabels;

  /// First day of each calendar month to label on the x-axis, oldest first.
  /// Ignored when [showWeekAxis] is `true`.
  final List<DateTime> months;

  /// Whether the month-name labels are tappable (the commission chart only).
  final bool clickableMonths;

  /// Whether to render the floating touch tooltip at all. Callers that show
  /// touch info inline instead (via [onTouchedIndexChanged]) pass `false`.
  final bool showTooltip;

  /// Resolves the tooltip text for the touched point at `index`. Only called
  /// when [showTooltip] is `true`.
  final String Function(int index) tooltipText;

  /// Called with a bucket's month when its label is tapped, when
  /// [clickableMonths] is `true`.
  final ValueChanged<DateTime>? onMonthTap;

  /// Called whenever the touched point's index changes, including `null` when
  /// the touch ends. Only needed to mirror the touched point elsewhere.
  final ValueChanged<int?>? onTouchedIndexChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final geometry = HistoryChartGeometry(chartWidth: constraints.maxWidth, pointCount: pointCount);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HistoryChartTouchLayer(
              geometry: geometry,
              spots: spots,
              minY: minY,
              maxY: maxY,
              colors: colors,
              isPositive: isPositive,
              height: height,
              showTooltip: showTooltip,
              tooltipText: tooltipText,
              onTouchedIndexChanged: onTouchedIndexChanged,
            ),
            const SizedBox(height: HistoryChartAxisLabels.gapAboveBand),
            HistoryChartAxisLabels(
              geometry: geometry,
              colors: colors,
              showWeekAxis: showWeekAxis,
              pointLabels: pointLabels,
              months: months,
              clickableMonths: clickableMonths,
              onMonthTap: onMonthTap,
            ),
          ],
        );
      },
    );
  }
}
