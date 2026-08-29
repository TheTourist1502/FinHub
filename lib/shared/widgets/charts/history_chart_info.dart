import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Small footnote text shown below a chart, e.g. "Data as of Jul 21, 2026".
///
/// Shared by the history-chart and allocation-chart footnotes so every chart
/// disclosure renders at the same size, weight, and colour.
class HistoryChartInfo extends StatelessWidget {
  /// Creates a [HistoryChartInfo].
  const HistoryChartInfo({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 10,
        color: colors.textSecondary,
        height: 1.25,
      ),
    );
  }
}
