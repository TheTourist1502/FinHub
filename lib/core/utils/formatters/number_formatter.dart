import 'package:intl/intl.dart';

/// Formats [value] as a grouped decimal number — e.g. `formatNumber(1234.5)`
/// → `"1,234.50"`, `formatNumber(37, fractionDigits: 4)` → `"37.0000"`.
///
/// Always renders exactly [fractionDigits] decimal places (trailing zeros
/// kept) so a column of numbers aligns on the decimal point. Pass
/// `fractionDigits: 0` for whole numbers.
///
/// This is a **display** helper: it returns a [String] and must only be
/// called at the point of rendering. Domain models keep their raw [double]
/// values so comparison, sorting and arithmetic continue to work.
///
/// The locale is pinned to `en_US` to match the rest of the app's numeric
/// output — grouping and decimal separators must not shift with the device
/// locale while the underlying figures are advisor-facing US dollars.
String formatNumber(num value, {int fractionDigits = 2}) {
  final pattern = fractionDigits > 0 ? '#,##0.${'0' * fractionDigits}' : '#,##0';
  return NumberFormat(pattern, 'en_US').format(value);
}
