import 'dart:math';

/// Pure pixel math for a history chart: where a data point sits horizontally,
/// how wide an axis-label slot is, and where the touch tooltip is placed.
///
/// Holds no widgets or canvas, so every position it returns can be reasoned
/// about (and tested) on its own.
class HistoryChartGeometry {
  /// Creates a geometry for a chart rendered [chartWidth] wide plotting
  /// [pointCount] points.
  const HistoryChartGeometry({required this.chartWidth, required this.pointCount});

  /// The chart's rendered width, in logical pixels.
  final double chartWidth;

  /// How many points are currently plotted.
  final int pointCount;

  /// Horizontal pixel position of the point at [index].
  ///
  /// No left column is reserved (the y-axis is never drawn), so points span
  /// the full width; a lone point is centered rather than pinned left.
  double pointX(double index) {
    final fraction = pointCount > 1 ? index / (pointCount - 1) : 0.5;
    return fraction * chartWidth;
  }

  /// Width of one point's share of the axis band, used to cap per-point date
  /// labels so the outermost two don't clamp against the chart's edges.
  double get pointSlotWidth => pointCount > 0 ? chartWidth / pointCount : chartWidth;

  /// Width of one month's uniform slot when [bucketCount] months are labelled.
  double monthSlotWidth(int bucketCount) => chartWidth / bucketCount;

  /// Center of the month slot at [index] — half a slot in, so labels sit
  /// between slot edges rather than on them.
  double monthCenterX(int index, int bucketCount) => (index + 0.5) * monthSlotWidth(bucketCount);

  /// Left edge of a [labelWidth]-wide label box centered on [centerX], clamped
  /// so the box never runs past either chart edge.
  double labelLeft(double centerX, double labelWidth) {
    final maxLeft = (chartWidth - labelWidth).clamp(0.0, chartWidth);
    return (centerX - labelWidth / 2).clamp(0.0, maxLeft);
  }

  /// Places the touch tooltip for the point at [index]: the bubble is centered
  /// on the point but clamped inside the chart, and its pointer then tracks the
  /// point within whatever offset that clamping left.
  HistoryChartTooltipPlacement tooltipPlacement({
    required int index,
    required double maxWidth,
    required double cornerInset,
  }) {
    final width = min(maxWidth, chartWidth);
    final x = pointX(index.toDouble());
    final maxLeft = (chartWidth - width).clamp(0.0, chartWidth);
    final left = (x - width / 2).clamp(0.0, maxLeft);
    final inset = min(cornerInset, width / 2);
    return HistoryChartTooltipPlacement(
      left: left,
      width: width,
      triangleOffset: (x - left).clamp(inset, width - inset),
    );
  }
}

/// Resolved position and size of the floating touch tooltip.
class HistoryChartTooltipPlacement {
  /// Creates a [HistoryChartTooltipPlacement].
  const HistoryChartTooltipPlacement({
    required this.left,
    required this.width,
    required this.triangleOffset,
  });

  /// Left edge of the bubble within the chart, in logical pixels.
  final double left;

  /// Rendered width of the bubble, in logical pixels.
  final double width;

  /// Where the pointer triangle's tip lands within [width], kept clear of the
  /// bubble's rounded corners.
  final double triangleOffset;
}
