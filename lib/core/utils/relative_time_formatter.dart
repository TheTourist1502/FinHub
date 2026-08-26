/// Coarse-grained unit a [RelativeTimeResult] is expressed in.
enum RelativeTimeUnit {
  /// Elapsed time is under a minute — no numeric count is shown.
  justNow,

  /// Elapsed time is one or more whole minutes, under an hour.
  minutes,

  /// Elapsed time is one or more whole hours, under a day.
  hours,

  /// Elapsed time is one or more whole days.
  days,
}

/// A bucketed elapsed-time value, e.g. "5 minutes" or "2 hours".
///
/// [count] is only meaningful when [unit] is not [RelativeTimeUnit.justNow].
class RelativeTimeResult {
  /// Creates a [RelativeTimeResult].
  const RelativeTimeResult(this.unit, this.count);

  /// The coarse-grained unit this result is expressed in.
  final RelativeTimeUnit unit;

  /// The number of whole [unit]s elapsed.
  final int count;
}

/// Buckets the elapsed time between [from] and [now] into a coarse unit +
/// count, suitable for "updated X ago" style display labels.
///
/// Under 60 seconds is [RelativeTimeUnit.justNow]; otherwise elapsed time is
/// expressed as whole minutes, then whole hours, then whole days.
RelativeTimeResult relativeTimeSince(DateTime from, DateTime now) {
  final elapsed = now.difference(from);

  if (elapsed.inSeconds < 60) return const RelativeTimeResult(RelativeTimeUnit.justNow, 0);
  if (elapsed.inMinutes < 60) return RelativeTimeResult(RelativeTimeUnit.minutes, elapsed.inMinutes);
  if (elapsed.inHours < 24) return RelativeTimeResult(RelativeTimeUnit.hours, elapsed.inHours);
  return RelativeTimeResult(RelativeTimeUnit.days, elapsed.inDays);
}
