import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/shared/widgets/charts/history_chart_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The "data as of" footnote under a history chart.
///
/// Commission gets a longer variant because its amounts are still awaiting
/// back-office validation and can change after they are first shown.
class HistoryChartFootnote extends StatelessWidget {
  /// Creates a [HistoryChartFootnote].
  const HistoryChartFootnote({
    required this.latestDate,
    required this.isCommissionChart,
    super.key,
  });

  /// The most recent date present in the full dataset.
  final DateTime latestDate;

  /// Whether to use the commission (unvalidated amounts) wording.
  final bool isCommissionChart;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy').format(latestDate);

    return HistoryChartInfo(
      text: isCommissionChart
          ? context.l10n.historyChartCommissionDataAsOf(dateStr)
          : context.l10n.historyChartDataAsOf(dateStr),
    );
  }
}
