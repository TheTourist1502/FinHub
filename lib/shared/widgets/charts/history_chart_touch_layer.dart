import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/widgets/charts/history_chart_geometry.dart';
import 'package:finhub/shared/widgets/charts/history_chart_line_data.dart';
import 'package:finhub/shared/widgets/charts/history_chart_tooltip.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// The plotted line plus the floating tooltip that tracks the touched point.
///
/// Owns the touched-point and reveal state, so a touch repaints only this
/// layer — never the axis-label band beside it or the section around it.
class HistoryChartTouchLayer extends StatefulWidget {
  /// Creates a [HistoryChartTouchLayer].
  const HistoryChartTouchLayer({
    required this.geometry,
    required this.spots,
    required this.minY,
    required this.maxY,
    required this.colors,
    required this.isPositive,
    required this.height,
    required this.showTooltip,
    required this.tooltipText,
    this.onTouchedIndexChanged,
    super.key,
  });

  /// Pixel math for this chart's width and point count.
  final HistoryChartGeometry geometry;

  /// The plotted line's data points.
  final List<FlSpot> spots;

  /// Lower bound of the plotted y scale, also the reveal animation's floor.
  final double minY;

  /// Upper bound of the plotted y scale.
  final double maxY;

  /// Theme tokens for the line, fill and tooltip.
  final AppColorTokens colors;

  /// Whether the series trends up, selecting the positive color pair.
  final bool isPositive;

  /// The chart's rendered height, which also anchors the tooltip's offset.
  final double height;

  /// Whether the floating tooltip renders at all.
  final bool showTooltip;

  /// Resolves the tooltip text for the touched point at `index`.
  final String Function(int index) tooltipText;

  /// Called whenever the touched point changes, including `null` on release.
  final ValueChanged<int?>? onTouchedIndexChanged;

  @override
  State<HistoryChartTouchLayer> createState() => _HistoryChartTouchLayerState();
}

class _HistoryChartTouchLayerState extends State<HistoryChartTouchLayer> {
  /// The tooltip bubble's maximum width, in logical pixels.
  static const double _tooltipMaxWidth = 175;

  /// How far the tooltip's pointer is kept from the bubble's rounded corners,
  /// so it never renders past them.
  static const double _tooltipCornerInset = 14;

  /// Index of the touched spot, or `null` when nothing is touched.
  int? _touchedIndex;

  /// `false` only on the first frame after mount, while the line is still
  /// flattened to the floor so fl_chart animates it growing upward.
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _revealed = true);
    });
  }

  /// Updates the touched point from a raw fl_chart touch event, clearing it on
  /// any end-style event or when no spot resolves.
  void _handleTouch(FlTouchEvent event, LineTouchResponse? response) {
    final spots = response?.lineBarSpots;

    if (isTouchEndEvent(event) || spots == null || spots.isEmpty) {
      if (_touchedIndex != null) {
        setState(() => _touchedIndex = null);
        widget.onTouchedIndexChanged?.call(null);
      }
      return;
    }

    final idx = spots.first.spotIndex;
    if (idx != _touchedIndex) {
      setState(() => _touchedIndex = idx);
      widget.onTouchedIndexChanged?.call(idx);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Guards against a stale index if the plotted point count changed without
    // this widget remounting.
    final touchedIndex = (_touchedIndex != null && _touchedIndex! < widget.geometry.pointCount) ? _touchedIndex : null;

    // Under reduce motion the line is plotted at its real values from the
    // first frame, so there is no flattened frame to flicker through.
    final plottedSpots = _revealed || !AppMotion.enabled(context)
        ? widget.spots
        : [for (final s in widget.spots) FlSpot(s.x, widget.minY)];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: widget.height,
          child: LineChart(
            HistoryChartLineData(
              spots: plottedSpots,
              minY: widget.minY,
              maxY: widget.maxY,
              colors: widget.colors,
              isPositive: widget.isPositive,
              touchedIndex: touchedIndex,
              onTouch: _handleTouch,
            ).build(),
            duration: AppMotion.duration(context, AppMotion.chart),
          ),
        ),
        ?_tooltip(touchedIndex),
      ],
    );
  }

  /// The floating bubble above the chart, or `null` when nothing is touched or
  /// the caller shows touch info inline instead.
  Widget? _tooltip(int? touchedIndex) {
    if (touchedIndex == null || !widget.showTooltip) return null;

    final placement = widget.geometry.tooltipPlacement(
      index: touchedIndex,
      maxWidth: _tooltipMaxWidth,
      cornerInset: _tooltipCornerInset,
    );
    return Positioned(
      left: placement.left,
      bottom: widget.height,
      child: HistoryChartTouchTooltip(
        text: widget.tooltipText(touchedIndex),
        colors: widget.colors,
        width: placement.width,
        triangleOffset: placement.triangleOffset,
      ),
    );
  }
}
