import 'package:intl/intl.dart';

/// Returns the date header to render above a transaction row, or `null` when
/// the row falls on the same calendar day as the row directly above it, or
/// when [date] itself is `null`.
///
/// Transaction lists are sorted as a whole — by date, amount, or name — and
/// then rendered flat. Emitting a label only when the day changes from
/// [previousDate] preserves the date-grouped look while never re-ordering
/// rows: under a date sort the labels land exactly where date group headers
/// used to, and under an amount or name sort the global order survives with
/// the date shown once per run of same-day rows.
///
/// [todayLabel] and [yesterdayLabel] are the localised strings for the two
/// relative days; pass `null` for [yesterdayLabel] on screens whose design
/// only special-cases today. Every other day formats as `MMMM d, yyyy`. All
/// results are uppercased.
///
/// A `null` [date] emits no header at all rather than a placeholder — an
/// undated row simply continues under whatever header precedes it.
///
/// [now] defaults to [DateTime.now] and exists so tests can pin the clock.
String? transactionDateLabel({
  required DateTime? date,
  required DateTime? previousDate,
  required String todayLabel,
  String? yesterdayLabel,
  DateTime? now,
}) {
  if (date == null) return null;
  if (previousDate != null && _isSameDay(date, previousDate)) return null;

  final today = now ?? DateTime.now();
  if (_isSameDay(date, today)) return todayLabel.toUpperCase();

  if (yesterdayLabel != null) {
    final yesterday = DateTime(today.year, today.month, today.day).subtract(const Duration(days: 1));
    if (_isSameDay(date, yesterday)) return yesterdayLabel.toUpperCase();
  }

  return DateFormat('MMMM d, yyyy').format(date).toUpperCase();
}

/// Whether [a] and [b] fall on the same calendar day.
bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
