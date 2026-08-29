import 'package:finhub/core/utils/date_sort_utils.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';

// ---------------------------------------------------------------------------
// Calendar-month range start
// ---------------------------------------------------------------------------

/// Returns the first day of the calendar-month window [filter] should show,
/// anchored at [now].
///
/// - **YTD** — January 1st of the current year.
/// - **6M** — the 1st of the month 5 months before [now] (6 calendar months
///   inclusive of the current one).
/// - **3M** — the 1st of the month 2 months before [now] (3 calendar months
///   inclusive of the current one).
/// - **1M** — the 1st of the current month.
///
/// [DateTime]'s constructor normalizes out-of-range months across year
/// boundaries, so `DateTime(now.year, now.month - 5, 1)` correctly rolls back
/// into the previous year when needed.
DateTime _rangeStart(DashboardFilter filter, DateTime now) {
  return switch (filter) {
    DashboardFilter.ytd => DateTime(now.year),
    DashboardFilter.sixMonths => DateTime(now.year, now.month - 5),
    DashboardFilter.threeMonths => DateTime(now.year, now.month - 2),
    DashboardFilter.oneMonth => DateTime(now.year, now.month),
  };
}

/// Returns the first day of every calendar month covered by [filter]'s
/// window, oldest first, anchored at [now] (defaulting to [DateTime.now()] —
/// pass it explicitly only to pin the "current" date in tests).
///
/// The list always ends at the current month and never depends on the data,
/// so an empty window still knows which months it *would* have covered — the
/// history chart uses it to keep labelling its x-axis when it has no points
/// to plot (1M → one month, 3M → three, YTD → January through today's month).
List<DateTime> filterWindowMonths(DashboardFilter filter, {DateTime? now}) {
  final effectiveNow = now ?? DateTime.now();
  final currentMonth = DateTime(effectiveNow.year, effectiveNow.month);
  final months = <DateTime>[];
  for (var m = _rangeStart(filter, effectiveNow); !m.isAfter(currentMonth); m = DateTime(m.year, m.month + 1)) {
    months.add(m);
  }
  return months;
}

// ---------------------------------------------------------------------------
// Available filter computation
// ---------------------------------------------------------------------------

/// Returns the subset of [DashboardFilter] values that are supported by the
/// available data, based on [oldestDate] relative to [now].
///
/// [now] defaults to [DateTime.now()] — the 1M/3M/6M/YTD windows are always
/// anchored to today's device-clock date, for every chart type, rather than
/// the latest available data point. Callers only need to pass [now]
/// explicitly in tests, to pin the "current" date deterministically.
///
/// **1M** is always offered — it's just the current calendar month, so it
/// needs no historical depth; when the current month has no data points yet,
/// [HistoryChartSection] renders an empty-state message instead of hiding
/// the chart. The other windows are only offered once the dataset actually
/// reaches back far enough to populate them:
/// - **3M** — oldest entry is on or before the 1st of the month 2 months back.
/// - **6M** — oldest entry is on or before the 1st of the month 5 months back.
/// - **YTD** — oldest entry falls within January of the current year.
List<DashboardFilter> availableFilters(DateTime oldestDate, {DateTime? now}) {
  final effectiveNow = now ?? DateTime.now();
  final result = <DashboardFilter>[DashboardFilter.oneMonth];

  if (oldestDate.isBefore(_rangeStart(DashboardFilter.threeMonths, effectiveNow))) {
    result.add(DashboardFilter.threeMonths);
  }
  if (oldestDate.isBefore(_rangeStart(DashboardFilter.sixMonths, effectiveNow))) {
    result.add(DashboardFilter.sixMonths);
  }
  // YTD: oldest entry is before or during January of the current year
  if (oldestDate.isBefore(DateTime(effectiveNow.year, 2))) {
    result.add(DashboardFilter.ytd);
  }
  return result;
}

// ---------------------------------------------------------------------------
// Filter application
// ---------------------------------------------------------------------------

/// Returns the subset of [entries] appropriate for [filter], sorted
/// chronologically.
///
/// Every filter is a calendar-month window anchored at [now] (defaulting to
/// [DateTime.now()] — pass it explicitly only to pin the "current" date in
/// tests): all entries whose date falls on or after the window start
/// computed by [_rangeStart] are included. For **1M** that window is just
/// the 1st of the current month through today, so the result can
/// legitimately be empty (e.g. no data has landed yet this month) —
/// callers should handle that case rather than treating it as an error.
///
/// Entries whose [getDate] is `null` (the backend sent no date, or an
/// unparseable one) are dropped outright: there is no x-axis position for a
/// point with no date, and plotting one at a fallback instant would invent
/// data. They are removed before sorting, so [compareDatesAsc]'s nulls-last
/// ordering never leaks into the plotted series.
List<T> filterEntries<T>(
  List<T> entries,
  DashboardFilter filter,
  DateTime? Function(T) getDate, {
  DateTime? now,
}) {
  if (entries.isEmpty) return [];
  final effectiveNow = now ?? DateTime.now();
  final sorted = [...entries.where((e) => getDate(e) != null)]..sort((a, b) => compareDatesAsc(getDate(a), getDate(b)));

  final rangeStart = _rangeStart(filter, effectiveNow);
  return sorted.where((e) => !getDate(e)!.isBefore(rangeStart)).toList();
}

// ---------------------------------------------------------------------------
// Month bucketing
// ---------------------------------------------------------------------------

/// A single calendar month's worth of data within a chronologically-sorted
/// entry list.
///
/// Used to render month-end markers and centered month-name axis labels on
/// `HistoryChartSection`.
class MonthBucket {
  /// Creates a [MonthBucket].
  const MonthBucket({
    required this.month,
    required this.startIndex,
    required this.endIndex,
    required this.total,
  });

  /// The first day of this bucket's calendar month, e.g. `DateTime(2026, 7)`.
  final DateTime month;

  /// The index, within the source list passed to [monthBuckets], of this
  /// month's first (earliest) entry.
  final int startIndex;

  /// The index, within the source list passed to [monthBuckets], of this
  /// month's last (most recent) entry.
  final int endIndex;

  /// The sum of every entry's value within this calendar month.
  final double total;
}

/// Groups chronologically-sorted [entries] by calendar month.
///
/// Returns one [MonthBucket] per distinct `(year, month)` present in
/// [entries], in chronological order, each carrying the index range of that
/// month's entries and the sum of all entries within that month.
///
/// [entries] must already be sorted chronologically (as returned by
/// [filterEntries]).
///
/// Entries with a `null` date are skipped rather than bucketed — they belong
/// to no calendar month, and [filterEntries] has normally removed them
/// already.
List<MonthBucket> monthBuckets<T>(
  List<T> entries,
  DateTime? Function(T) getDate,
  double Function(T) getValue,
) {
  final buckets = <MonthBucket>[];
  DateTime? currentMonth;
  var sum = 0.0;
  var startIndex = -1;
  var endIndex = -1;

  for (var i = 0; i < entries.length; i++) {
    final date = getDate(entries[i]);
    // A dateless entry belongs to no month; skip it rather than folding its
    // value into whichever bucket happens to be open.
    if (date == null) continue;
    final monthKey = DateTime(date.year, date.month);
    if (currentMonth == null || monthKey != currentMonth) {
      if (currentMonth != null) {
        buckets.add(MonthBucket(month: currentMonth, startIndex: startIndex, endIndex: endIndex, total: sum));
      }
      currentMonth = monthKey;
      sum = 0;
      startIndex = i;
    }
    sum += getValue(entries[i]);
    endIndex = i;
  }

  if (currentMonth != null) {
    buckets.add(MonthBucket(month: currentMonth, startIndex: startIndex, endIndex: endIndex, total: sum));
  }

  return buckets;
}
