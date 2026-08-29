import 'dart:math';

import 'package:fl_chart/fl_chart.dart';

/// The plotted geometry and headline numbers derived from a history chart's
/// currently visible values. Pure data, so the math stays out of `build`.
class HistoryChartMetrics {
  /// Creates a metrics set directly from already-computed values.
  const HistoryChartMetrics({
    required this.displayValues,
    required this.latestValue,
    required this.change,
    required this.changePercent,
    required this.isPositive,
    required this.changeIsPositive,
    required this.spots,
    required this.minY,
    required this.maxY,
  });

  /// The neutral metrics used when the selected window has no data points.
  const HistoryChartMetrics.empty()
    : displayValues = const <double>[],
      latestValue = 0,
      change = 0,
      changePercent = 0,
      isPositive = true,
      changeIsPositive = true,
      spots = const <FlSpot>[],
      minY = 0,
      maxY = 0;

  /// Computes the metrics for [values], the plotted points in order.
  ///
  /// [touchedIndex] swaps the period's latest point for the touched one in
  /// [latestValue] and [change]; a stale index falls back to the last point.
  factory HistoryChartMetrics.from({
    required List<double> values,
    required bool isCommission,
    int? touchedIndex,
  }) {
    final restLatestValue = values.last;
    final earliestValue = values.first;

    final displayedIndex = (touchedIndex != null && touchedIndex < values.length) ? touchedIndex : values.length - 1;
    final latestValue = values[displayedIndex];

    final double change;
    final double changePercent;
    final bool isPositive;
    final bool changeIsPositive;

    if (isCommission) {
      // A sum of per-period earnings, not a first-vs-last delta, which would
      // be meaningless here. Never touch-reactive — commission charts don't
      // report a touched index up.
      change = values.reduce((a, b) => a + b);
      changePercent = 0;
      isPositive = change >= 0;
      changeIsPositive = isPositive;
    } else {
      change = latestValue - earliestValue;
      changePercent = earliestValue > 0 ? (change / earliestValue) * 100 : 0.0;
      // Anchored to the untouched trend so the line's colour never flickers
      // while scrubbing; only the change row's own sign reacts to touch, so
      // the two flags can legitimately disagree.
      isPositive = (restLatestValue - earliestValue) >= 0;
      changeIsPositive = change >= 0;
    }

    var rawMin = values.first;
    var rawMax = values.first;
    for (final v in values.skip(1)) {
      if (v < rawMin) rawMin = v;
      if (v > rawMax) rawMax = v;
    }
    final padding = (rawMax - rawMin) * 0.15;

    return HistoryChartMetrics(
      displayValues: values,
      latestValue: latestValue,
      change: change,
      changePercent: changePercent,
      isPositive: isPositive,
      changeIsPositive: changeIsPositive,
      spots: [for (final (i, v) in values.indexed) FlSpot(i.toDouble(), v)],
      // min(0, rawMin) rather than a bare 0 so a genuine negative point (an
      // AUM drawdown, a commission clawback) stays on screen.
      minY: min(0, rawMin),
      maxY: rawMax + (padding > 0 ? padding : rawMax * 0.05),
    );
  }

  /// The plotted values, in x-axis order.
  final List<double> displayValues;

  /// The value shown as the hero figure — the touched point when there is
  /// one, otherwise the period's latest.
  final double latestValue;

  /// The change row's amount: a period delta, or a sum for commission.
  final double change;

  /// The period delta as a percentage of its starting value; always 0 for
  /// commission, which shows no percentage.
  final double changePercent;

  /// Whether the period's untouched trend is upward — drives the line colour.
  final bool isPositive;

  /// Whether [change] itself is non-negative — drives the change row's sign.
  final bool changeIsPositive;

  /// The plotted points for the line chart.
  final List<FlSpot> spots;

  /// The y-axis floor, never above zero.
  final double minY;

  /// The y-axis ceiling, padded above the highest point so the line has
  /// headroom.
  final double maxY;
}
