import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/chart_filter_utils.dart';
import 'package:finhub/core/utils/currency_utils.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:finhub/shared/widgets/charts/history_chart_canvas.dart';
import 'package:finhub/shared/widgets/charts/history_chart_change_row.dart';
import 'package:finhub/shared/widgets/charts/history_chart_empty_state.dart';
import 'package:finhub/shared/widgets/charts/history_chart_filter_chips.dart';
import 'package:finhub/shared/widgets/charts/history_chart_footnote.dart';
import 'package:finhub/shared/widgets/charts/history_chart_header.dart';
import 'package:finhub/shared/widgets/charts/history_chart_metrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Identifies which metric a [HistoryChartSection] is plotting.
///
/// Only commission vs. AUM is branched on today; the two AUM variants stay
/// distinct so a per-context difference can be added without a new API.
enum HistoryChartContext {
  /// The FA's total AUM across all accounts.
  totalAum,

  /// The FA's total commission earned.
  totalCommission,

  /// A single account's AUM.
  accountAum,
}

/// A full history chart section: optional header, area line chart, filter
/// chips and footnote. Used by both the AUM and commission sections.
///
/// Padding is intentionally omitted — the parent owns all insets.
class HistoryChartSection<T> extends StatelessWidget {
  /// Creates a [HistoryChartSection].
  const HistoryChartSection({
    required this.entries,
    required this.filterProvider,
    required this.getDate,
    required this.getValue,
    required this.label,
    required this.chartContext,
    this.onTouchedEntryChanged,
    this.showHeader = true,
    this.isCompact = false,
    this.height = 96,
    super.key,
  });

  /// The full dataset — all weekly data points for this history type.
  final List<T> entries;

  /// Holds the currently selected filter.
  final NotifierProvider<DashboardFilterNotifier, DashboardFilter> filterProvider;

  /// Extracts the [DateTime] from an entry, or `null` when the backend sent
  /// no date — such entries are dropped from the series rather than plotted.
  final DateTime? Function(T) getDate;

  /// Extracts the numeric value (AUM or commission) from an entry.
  final double Function(T) getValue;

  /// Eyebrow label shown above the total (e.g. "TOTAL AUM"). Ignored when
  /// [showHeader] is `false`.
  final String label;

  /// Which metric this chart plots, used to tag tooltip content.
  final HistoryChartContext chartContext;

  /// Called with the touched data point, or `null` when the touch ends.
  ///
  /// Wiring it also makes the change row's delta track the touched point, so
  /// a caller rendering its own hero value above the chart can mirror it.
  final void Function(T? entry)? onTouchedEntryChanged;

  /// Whether to render the eyebrow label and hero value.
  final bool showHeader;

  /// Tightens the vertical gaps around the chart so the section fits in a
  /// shorter card (used by the commission details header).
  final bool isCompact;

  /// The line chart's rendered height, in logical pixels.
  final double height;

  @override
  Widget build(BuildContext context) {
    return _HistoryChartContent<T>(
      entries: entries,
      filterProvider: filterProvider,
      getDate: getDate,
      getValue: getValue,
      label: label,
      chartContext: chartContext,
      onTouchedEntryChanged: onTouchedEntryChanged,
      showHeader: showHeader,
      isCompact: isCompact,
      height: height,
    );
  }
}

/// Stateful body of [HistoryChartSection] — owns the drilled-into month and
/// the mirrored touched-point index.
class _HistoryChartContent<T> extends ConsumerStatefulWidget {
  const _HistoryChartContent({
    required this.entries,
    required this.filterProvider,
    required this.getDate,
    required this.getValue,
    required this.label,
    required this.chartContext,
    this.onTouchedEntryChanged,
    this.showHeader = true,
    this.isCompact = false,
    this.height = 96,
    super.key,
  });

  final List<T> entries;
  final NotifierProvider<DashboardFilterNotifier, DashboardFilter> filterProvider;
  final DateTime? Function(T) getDate;
  final double Function(T) getValue;
  final String label;
  final HistoryChartContext chartContext;
  final void Function(T? entry)? onTouchedEntryChanged;
  final bool showHeader;
  final bool isCompact;
  final double height;

  @override
  ConsumerState<_HistoryChartContent<T>> createState() => _HistoryChartContentState<T>();
}

class _HistoryChartContentState<T> extends ConsumerState<_HistoryChartContent<T>> {
  /// The calendar month drilled into (normalized to its 1st), or `null` for
  /// the full filter range. Commission chart only.
  DateTime? _selectedMonth;

  /// Index of the touched point, mirrored from [HistoryChartCanvas]. Only
  /// populated when the caller supplied `onTouchedEntryChanged`.
  int? _touchedIndex;

  /// The filter used for the last build, tracked only to detect a genuine
  /// change — the `available.last` fallback can re-resolve identically on
  /// every build, which must not count as a new event.
  DashboardFilter? _lastResolvedFilter;

  /// Returns the bucket matching [month], or `null` when the selection is
  /// stale (e.g. the entries reloaded without it).
  MonthBucket? _findBucket(List<MonthBucket> buckets, DateTime month) {
    for (final bucket in buckets) {
      if (bucket.month == month) return bucket;
    }
    return null;
  }

  /// Drops the touched point and notifies the caller of the release, so a
  /// stale index never carries into a differently-shaped chart.
  void _clearTouchedIndex() {
    if (_touchedIndex == null) return;
    _touchedIndex = null;
    widget.onTouchedEntryChanged?.call(null);
  }

  /// [_clearTouchedIndex] deferred to a post-frame callback — used from
  /// `build` and `didUpdateWidget`, where `setState` would assert.
  void _clearTouchedIndexDeferred() {
    if (_touchedIndex == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(_clearTouchedIndex);
    });
  }

  @override
  void didUpdateWidget(covariant _HistoryChartContent<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A new list identity means the data actually refreshed, so the touched
    // point may no longer refer to the same entry.
    if (!identical(widget.entries, oldWidget.entries)) {
      _clearTouchedIndexDeferred();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) return const SizedBox.shrink();

    final colors = context.appColors;

    // Commission gets a distinct interaction set: zero-based unlabelled
    // y-axis, tappable month labels, per-week tooltips, sum-total change row.
    final isCommissionChart = widget.chartContext == HistoryChartContext.totalCommission;

    // Undated entries can never be plotted, so they also can't widen the
    // range of offered filters — drop them before computing the extremes.
    final datedEntries = widget.entries.map(widget.getDate).nonNulls.toList();
    if (datedEntries.isEmpty) return const SizedBox.shrink();
    final oldestDate = datedEntries.reduce((a, b) => a.isBefore(b) ? a : b);
    final latestDate = datedEntries.reduce((a, b) => a.isAfter(b) ? a : b);
    // Filter windows anchor to today's device clock, not the latest data
    // point, so a window always reflects the current calendar period.
    final available = availableFilters(oldestDate);
    if (available.isEmpty) return const SizedBox.shrink();

    var selected = ref.watch<DashboardFilter>(widget.filterProvider);
    if (!available.contains(selected)) {
      selected = available.last;
    }
    if (_lastResolvedFilter != null && _lastResolvedFilter != selected) {
      _clearTouchedIndexDeferred();
    }
    _lastResolvedFilter = selected;

    // Every filter is a calendar-month window, so 1M can legitimately come
    // back empty mid-month; that renders a "-" row plus an empty chart.
    final filtered = filterEntries(widget.entries, selected, widget.getDate);
    final hasData = filtered.isNotEmpty;

    // Month buckets drive the month-name x-axis labels and month taps. Not
    // needed for 1M, which is already at week granularity.
    final buckets = (hasData && selected != DashboardFilter.oneMonth)
        ? monthBuckets(filtered, widget.getDate, widget.getValue)
        : const <MonthBucket>[];

    // Commission only: a tapped month narrows the chart to that month's
    // weeks. A stale selection quietly falls back to the full range.
    final selectedBucket = (isCommissionChart && _selectedMonth != null) ? _findBucket(buckets, _selectedMonth!) : null;
    final plotted = selectedBucket != null
        ? filtered.sublist(selectedBucket.startIndex, selectedBucket.endIndex + 1)
        : filtered;
    final showWeekAxis = selected == DashboardFilter.oneMonth || selectedBucket != null;

    // Single-month views label each point with its own date ("26 Jul") rather
    // than a week ordinal; the year is dropped since every point shares it.
    final pointLabels = showWeekAxis
        // `plotted` comes from `filterEntries`, which has already dropped
        // every undated entry, so the date is non-null here.
        ? [for (final e in plotted) DateFormat('d MMM').format(widget.getDate(e)!)]
        : const <String>[];

    final metrics = hasData
        ? HistoryChartMetrics.from(
            values: plotted.map(widget.getValue).toList(),
            isCommission: isCommissionChart,
            touchedIndex: _touchedIndex,
          )
        : const HistoryChartMetrics.empty();

    /// The 1-based position of point [idx] within its own calendar month,
    /// matching the W1/W2/... labels.
    int weekNumberFor(int idx) {
      if (showWeekAxis) return idx + 1;
      for (final bucket in buckets) {
        if (idx >= bucket.startIndex && idx <= bucket.endIndex) return idx - bucket.startIndex + 1;
      }
      return idx + 1;
    }

    /// Tooltip body for the touched point. Only resolved for the commission
    /// chart, the only one with `showTooltip: true`.
    String tooltipText(int idx) {
      final valueStr = compactDollar(metrics.displayValues[idx]);
      final dateStr = DateFormat('MMM d, yyyy').format(widget.getDate(plotted[idx])!);
      return context.l10n.historyChartWeekTooltip(weekNumberFor(idx), dateStr, valueStr);
    }

    /// Mirrors the canvas's touched point locally and reports it to the
    /// caller. Only wired up when `onTouchedEntryChanged` was supplied.
    void handleTouchedIndexChanged(int? idx) {
      setState(() => _touchedIndex = idx);
      widget.onTouchedEntryChanged?.call(idx == null ? null : plotted[idx]);
    }

    // While a point is touched on an AUM chart, the change row's trailing
    // segment shows that point's date instead of the filter label. The
    // commission chart uses that same segment for its breadcrumb.
    final touchedDateLabel = (!isCommissionChart && hasData && _touchedIndex != null && _touchedIndex! < plotted.length)
        ? DateFormat('MMM d, yyyy').format(widget.getDate(plotted[_touchedIndex!])!)
        : null;

    final gap = widget.isCompact ? 8.0 : 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showHeader)
          HistoryChartHeader(
            label: widget.label,
            value: metrics.latestValue,
            hasData: hasData,
          ),
        HistoryChartChangeRow(
          hasData: hasData,
          showPercent: !isCommissionChart,
          change: metrics.change,
          changePercent: metrics.changePercent,
          isPositive: metrics.changeIsPositive,
          filterLabel: _rangeLabel(context, selected),
          touchedDateLabel: touchedDateLabel,
          selectedMonthLabel: selectedBucket == null ? null : DateFormat('MMM').format(selectedBucket.month),
          onFilterLabelTap: selectedBucket == null
              ? null
              : () => setState(() {
                  _selectedMonth = null;
                  _clearTouchedIndex();
                }),
          isCommissionChart: isCommissionChart,
          // The plotted range, which is what makes the delta a genuinely
          // different number — a touch along the chart is excluded on purpose.
          revealKey: (selected, selectedBucket?.month),
        ),
        SizedBox(height: gap),
        if (!hasData)
          // Nothing to plot, but the window's own months still label the
          // x-axis: 1M shows the current month centered, 3M shows all three.
          HistoryChartEmptyState(
            message: context.l10n.historyChartNoData,
            colors: colors,
            months: filterWindowMonths(selected),
            height: widget.height,
          )
        else
          // Keyed on everything that determines the plotted dataset, so any
          // of them remounts the canvas with fresh touch state and replays
          // its grow-in-from-the-floor reveal animation.
          HistoryChartCanvas(
            key: ValueKey((selected, _selectedMonth, widget.entries)),
            spots: metrics.spots,
            minY: metrics.minY,
            maxY: metrics.maxY,
            colors: colors,
            isPositive: metrics.isPositive,
            pointCount: plotted.length,
            showWeekAxis: showWeekAxis,
            pointLabels: pointLabels,
            // Only months that actually carry data get labelled here, so a
            // window with a single populated month reads as just that month.
            months: [for (final b in buckets) b.month],
            clickableMonths: isCommissionChart && !showWeekAxis,
            // The floating tooltip is the fallback for charts that don't
            // already surface touch info inline, so it keys off whether the
            // callback was supplied rather than off the chart type.
            showTooltip: widget.onTouchedEntryChanged == null,
            tooltipText: tooltipText,
            height: widget.height,
            onTouchedIndexChanged: widget.onTouchedEntryChanged == null ? null : handleTouchedIndexChanged,
            onMonthTap: !isCommissionChart
                ? null
                : (month) => setState(() {
                    _selectedMonth = month;
                    _clearTouchedIndex();
                  }),
          ),
        SizedBox(height: gap),
        HistoryChartFilterChips(
          available: available,
          selected: selected,
          onSelect: (f) => setState(() {
            ref.read(widget.filterProvider.notifier).select(f);
            _selectedMonth = null;
            _clearTouchedIndex();
          }),
        ),
        SizedBox(height: widget.isCompact ? 6 : 10),
        HistoryChartFootnote(latestDate: latestDate, isCommissionChart: isCommissionChart),
      ],
    );
  }

  /// The spelled-out name of [filter]'s window for the change row — longer
  /// than [DashboardFilter.label], which stays terse for the fixed-width
  /// chip row.
  String _rangeLabel(BuildContext context, DashboardFilter filter) {
    final l10n = context.l10n;
    return switch (filter) {
      DashboardFilter.oneMonth => l10n.historyChartRangeCurrentMonth,
      DashboardFilter.threeMonths => l10n.historyChartRangePastThreeMonths,
      DashboardFilter.sixMonths => l10n.historyChartRangePastSixMonths,
      DashboardFilter.ytd => l10n.historyChartRangeYtd,
    };
  }
}
