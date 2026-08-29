import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/widgets/charts/history_chart_widget.dart';
import 'package:finhub/shared/widgets/currency/currency_hero_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// An "AUM Trend"-style card body: an eyebrow label, a touch-reactive hero
/// value + trailing label, and the [HistoryChartSection] chart beneath it.
///
/// Touching a point on the chart swaps the hero value and its trailing
/// label for that point's own value and date; both revert to [restValue]
/// and [restLabel] once the touch ends. Shared by the Dashboard's Total AUM
/// section and the Account Detail's AUM Trend card, which otherwise
/// duplicated this exact pattern.
class TouchReactiveAumHero<T> extends StatefulWidget {
  /// Creates a [TouchReactiveAumHero].
  const TouchReactiveAumHero({
    required this.eyebrowLabel,
    required this.restValue,
    required this.restLabel,
    required this.entries,
    required this.filterProvider,
    required this.getDate,
    required this.getValue,
    required this.chartContext,
    this.emptyMessage,
    super.key,
  });

  /// Text shown above the hero value (e.g. "Total AUM", "AUM Trend").
  final String eyebrowLabel;

  /// The authoritative value shown as the hero at rest (untouched) — and
  /// whenever [entries] is empty, if [emptyMessage] is set.
  final double restValue;

  /// The trailing label shown next to [restValue] at rest (e.g. "YTD").
  final String restLabel;

  /// The full dataset for the chart below.
  final List<T> entries;

  /// Riverpod [NotifierProvider] that holds the currently selected filter.
  final NotifierProvider<DashboardFilterNotifier, DashboardFilter> filterProvider;

  /// Extracts the [DateTime] from an entry, or `null` when the backend sent
  /// no date — such entries are dropped from the chart below.
  final DateTime? Function(T) getDate;

  /// Extracts the numeric value from an entry.
  final double Function(T) getValue;

  /// Identifies which metric this chart plots.
  final HistoryChartContext chartContext;

  /// Message shown in place of the chart when [entries] is empty. Leave
  /// `null` (the default) when the caller already guarantees non-empty
  /// entries — the hero row itself always renders regardless.
  final String? emptyMessage;

  @override
  State<TouchReactiveAumHero<T>> createState() => _TouchReactiveAumHeroState<T>();
}

class _TouchReactiveAumHeroState<T> extends State<TouchReactiveAumHero<T>> {
  /// The entry currently touched on the chart below, or `null` when nothing
  /// is touched.
  T? _touchedEntry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final eyebrow = Text(
      widget.eyebrowLabel,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: colors.textSecondary,
        letterSpacing: 0.7,
        height: 14 / 14,
      ),
    );

    // `_touchedEntry` can only be non-null once a chart has been touched, so
    // this is always `restValue`/`restLabel` whenever `entries` is empty
    // below — the hero never depends on chart history being available.
    final touched = _touchedEntry;
    final heroValue = touched != null ? widget.getValue(touched) : widget.restValue;
    // A touched entry always came from the plotted series, which is dated by
    // construction. Falling back to `restLabel` on a null date keeps the
    // trailing slot meaningful instead of ever showing a placeholder date.
    final touchedDate = touched == null ? null : widget.getDate(touched);
    final heroLabel = touchedDate == null ? widget.restLabel : DateFormat('MMM d, yyyy').format(touchedDate);
    final heroRow = Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Rolls in on first appearance only; touch updates land immediately.
        CurrencyHeroValue(value: heroValue),
        const SizedBox(width: 4),
        Text(
          heroLabel,
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 14, color: colors.textSecondary),
        ),
      ],
    );

    final emptyMessage = widget.emptyMessage;
    if (widget.entries.isEmpty && emptyMessage != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          eyebrow,
          const SizedBox(height: 12),
          heroRow,
          const SizedBox(height: 4),
          SizedBox(
            height: 64,
            child: Center(
              child: Text(
                emptyMessage,
                style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: colors.textSecondary),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        eyebrow,
        const SizedBox(height: 12),
        heroRow,
        const SizedBox(height: 4),
        // Delayed one stagger step behind the hero value so the number leads
        // and the line prints in beneath it, rather than both arriving at once.
        SettleIn(
          index: 2,
          child: HistoryChartSection<T>(
            showHeader: false,
            entries: widget.entries,
            filterProvider: widget.filterProvider,
            getDate: widget.getDate,
            getValue: widget.getValue,
            label: widget.eyebrowLabel,
            chartContext: widget.chartContext,
            onTouchedEntryChanged: (entry) => setState(() => _touchedEntry = entry),
          ),
        ),
      ],
    );
  }
}
