import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/shared/widgets/charts/history_chart_info.dart';
import 'package:flutter/material.dart';

/// The rounding-disclosure footnote under an asset-allocation donut chart.
///
/// The donut's centre label and legend both round what they display — market
/// values to two decimals, allocation percentages to one — so slices can look
/// as though they do not sum to exactly 100%. Every allocation card (dashboard,
/// household detail, account detail) shows this same note, so the wording lives
/// here rather than being repeated at each call site.
class AllocationChartFootnote extends StatelessWidget {
  /// Creates an [AllocationChartFootnote].
  const AllocationChartFootnote({super.key});

  @override
  Widget build(BuildContext context) {
    return HistoryChartInfo(text: context.l10n.allocationChartRoundingNote);
  }
}
