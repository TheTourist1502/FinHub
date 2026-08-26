import 'package:intl/intl.dart';

/// Formats [value] as a compact dollar amount, scaling to K/M/B suffixes
/// above 1,000 and rounding to at most [decimalPoints] decimal places
/// (trailing zeros trimmed) — e.g. `compactDollar(1234.5)` → `"$1.23K"`,
/// `compactDollar(137.4)` → `"$137.4"` with `decimalPoints: 1`.
///
/// [NumberFormat.compact] is deliberately not used here: its
/// significant-figures rounding drops decimals entirely once the integer
/// part is already 3 digits, silently truncating real cents on any value
/// under $1,000 (e.g. $137.42 → "$137") — unacceptable precision loss for a
/// dollar amount.
String compactDollar(double value, {int decimalPoints = 2}) {
  final magnitude = value.abs();
  final sign = value < 0 ? '-' : '';
  final pattern = decimalPoints > 0 ? '#,##0.${'#' * decimalPoints}' : '#,##0';
  String scaled(double scaledValue, String suffix) =>
      '$sign\$${NumberFormat(pattern, 'en_US').format(scaledValue)}$suffix';

  if (magnitude >= 1e9) return scaled(magnitude / 1e9, 'B');
  if (magnitude >= 1e6) return scaled(magnitude / 1e6, 'M');
  if (magnitude >= 1e3) return scaled(magnitude / 1e3, 'K');
  return scaled(magnitude, '');
}
