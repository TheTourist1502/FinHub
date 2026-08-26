import 'package:intl/intl.dart';

/// Formats backend-sourced timestamps for display.
///
/// Backend timestamps are always sent in UTC. Formatting a raw parsed
/// `DateTime` with [DateFormat.format] shows the user UTC wall-clock time
/// instead of their own — this extension converts to local time first, so
/// call sites never need to remember a bare `.toLocal()`.
///
/// Only use this for values that represent an instant with meaningful
/// time-of-day (e.g. `createdAt`, login time, an "as of" snapshot). Pure
/// calendar dates with no time component (e.g. date of birth, a trade date)
/// should keep using [DateFormat.format] directly, since converting them to
/// local time risks shifting the calendar day.
extension LocalDateFormat on DateFormat {
  /// Converts [dateTime] from UTC to the device's local time zone, then
  /// formats it with this [DateFormat].
  String formatLocal(DateTime dateTime) => format(dateTime.toLocal());
}
