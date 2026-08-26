/// Null-safe ordering helpers for the nullable [DateTime] fields that every
/// API model now exposes.
///
/// Backend date fields parse through `parseOptionalDateTime`, so any of them
/// can be `null` when the value was absent or unparseable. Sorting such a list
/// with a bare `a.date.compareTo(b.date)` no longer compiles, and the naive
/// fix — substituting an epoch fallback — buries missing rows at one end of
/// the list in ascending order and floats them to the top in descending order,
/// which reads as real data.
///
/// These helpers keep null-dated records at the **end** of the list in both
/// directions, so "no date" is never mistaken for "oldest" or "newest".
library;

/// Compares two nullable dates in ascending order, placing `null` last.
///
/// Two null dates compare equal, preserving their relative input order under
/// a stable sort.
int compareDatesAsc(DateTime? a, DateTime? b) {
  if (a == null && b == null) return 0;
  if (a == null) return 1;
  if (b == null) return -1;
  return a.compareTo(b);
}

/// Compares two nullable dates in descending order, placing `null` last.
///
/// Deliberately not `-compareDatesAsc(a, b)`: negating would flip the null
/// rows to the front. Only the two non-null cases reverse.
int compareDatesDesc(DateTime? a, DateTime? b) {
  if (a == null && b == null) return 0;
  if (a == null) return 1;
  if (b == null) return -1;
  return b.compareTo(a);
}

/// Compares two nullable dates in the requested direction, nulls last.
///
/// Convenience for the many list views that hold sort direction in a flag.
int compareDates(DateTime? a, DateTime? b, {required bool descending}) =>
    descending ? compareDatesDesc(a, b) : compareDatesAsc(a, b);
