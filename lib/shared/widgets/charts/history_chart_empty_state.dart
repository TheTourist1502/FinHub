import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/widgets/charts/history_chart_axis_labels.dart';
import 'package:finhub/shared/widgets/charts/history_chart_geometry.dart';
import 'package:flutter/material.dart';

/// Shown in place of the line chart when the selected filter window has no
/// data points (e.g. 1M selected before any data has landed this month).
///
/// Renders as an empty chart rather than a blank slate: the plot area holds
/// only [message], and the same x-axis band a populated chart would draw sits
/// beneath it, naming [months] — the calendar months the selected window
/// covers. So 1M keeps its single month centered, 3M still reads Jun/Jul/Aug,
/// and switching filters never collapses the section's height.
///
/// [height] should match the chart's own height so the surrounding layout
/// doesn't shift when switching between an empty and populated filter.
/// Defaults to 96.
class HistoryChartEmptyState extends StatelessWidget {
  /// Creates a [HistoryChartEmptyState].
  const HistoryChartEmptyState({
    required this.message,
    required this.colors,
    required this.months,
    this.height = 96,
    super.key,
  });

  /// The "no data for this period" copy shown where the line would be.
  final String message;

  /// Theme tokens supplying the message and axis-label colors.
  final AppColorTokens colors;

  /// First day of each calendar month the selected window covers, oldest
  /// first — labelled along the x-axis in uniform slots.
  final List<DateTime> months;

  /// The plot area's height, matching the chart it stands in for.
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height,
              child: Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: HistoryChartAxisLabels.gapAboveBand),
            HistoryChartAxisLabels(
              // No points are plotted, so the geometry only ever resolves
              // month slots — the point-position math is never reached.
              geometry: HistoryChartGeometry(chartWidth: constraints.maxWidth, pointCount: 0),
              colors: colors,
              showWeekAxis: false,
              pointLabels: const [],
              months: months,
              clickableMonths: false,
            ),
          ],
        );
      },
    );
  }
}
