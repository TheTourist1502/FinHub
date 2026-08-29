import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:fl_chart/fl_chart.dart';

/// Builds the [LineChartData] for a history chart: one curved, area-filled line
/// with all of fl_chart's own axes, grid and built-in tooltip switched off.
///
/// Kept apart from the widget so the chart's configuration can be read (and
/// changed) without wading through layout code.
class HistoryChartLineData {
  /// Creates a [HistoryChartLineData].
  const HistoryChartLineData({
    required this.spots,
    required this.minY,
    required this.maxY,
    required this.colors,
    required this.isPositive,
    required this.touchedIndex,
    required this.onTouch,
  });

  /// The points to plot, already flattened to the floor during the reveal.
  final List<FlSpot> spots;

  /// Lower bound of the plotted y scale.
  final double minY;

  /// Upper bound of the plotted y scale.
  final double maxY;

  /// Theme tokens supplying the line, fill and dot-stroke colors.
  final AppColorTokens colors;

  /// Whether the series trends up, selecting the positive color pair.
  final bool isPositive;

  /// Index of the touched point whose dot should show, or `null`.
  final int? touchedIndex;

  /// Raw fl_chart touch callback driving the custom tooltip.
  final void Function(FlTouchEvent, LineTouchResponse?) onTouch;

  /// Assembles the chart configuration.
  LineChartData build() {
    final fillColor = isPositive ? colors.chartFillPositive : colors.chartFillNegative;
    final lineColor = isPositive ? colors.bgBrandNavyBlue : colors.statusErrorDefault;

    // With one spot fl_chart infers a zero-width x domain and pins the dot to
    // the left edge, so pad the domain by 0.5 each side to center it — matching
    // how the geometry helper centers a lone point's tooltip and label.
    final onlySpot = spots.length == 1;

    return LineChartData(
      minX: onlySpot ? -0.5 : null,
      maxX: onlySpot ? 0.5 : null,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: lineColor,
          dotData: FlDotData(
            // A lone point has no line to draw, so its dot shows unconditionally
            // rather than only on touch — otherwise the chart looks empty.
            checkToShowDot: (spot, _) => spot.x.toInt() == touchedIndex || onlySpot,
            getDotPainter: (spot, _, _, _) => FlDotCirclePainter(
              radius: 4,
              color: lineColor,
              strokeWidth: 2,
              strokeColor: colors.surfaceDefault,
            ),
          ),
          belowBarData: BarAreaData(show: true, color: fillColor),
        ),
      ],
      // All axis text is off: the month/week labels render in their own band
      // below the chart box, where they can't overlap the line and can sit at
      // fractional x positions. minY/maxY still govern the scale.
      titlesData: const FlTitlesData(
        topTitles: AxisTitles(),
        rightTitles: AxisTitles(),
        bottomTitles: AxisTitles(),
        leftTitles: AxisTitles(),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        // The built-in tooltip can only paint inside the chart's own short
        // bounds, so it is replaced by the overlay bubble driven by onTouch.
        handleBuiltInTouches: false,
        touchCallback: onTouch,
        // The default 10px threshold rejects most of the surface once points
        // sit further apart than that (e.g. YTD). Only one line exists, so an
        // unbounded x-distance safely resolves every touch to its nearest point.
        touchSpotThreshold: double.infinity,
      ),
    );
  }
}

/// Whether [event] ends a touch — release, cancel, or the pointer leaving the
/// chart — and so should clear the touched point.
bool isTouchEndEvent(FlTouchEvent event) =>
    event is FlPanEndEvent ||
    event is FlPanCancelEvent ||
    event is FlTapUpEvent ||
    event is FlTapCancelEvent ||
    event is FlLongPressEnd ||
    event is FlPointerExitEvent;
