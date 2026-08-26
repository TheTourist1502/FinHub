import 'package:finhub/core/utils/formatters/number_formatter.dart';

/// Formats [value] as a percentage — e.g. `formatPercentage(9.6)` → `"9.6%"`,
/// `formatPercentage(-2.35, signed: true)` → `"-2.4%"`.
///
/// [value] is expected **already scaled to 0–100**, which is how every
/// percentage field in the API arrives (`allocationPercentage: "40.00"`,
/// `aumChangePercentage: 9.60`). It is not multiplied by 100 here.
///
/// Set [signed] to `true` for change/delta figures that should carry an
/// explicit `+` when positive; negatives always keep their `-`.
///
/// This is a **display** helper: it returns a [String] and must only be called
/// at the point of rendering. Domain models keep their raw [double] values so
/// comparison, sorting and arithmetic continue to work.
String formatPercentage(num value, {int fractionDigits = 1, bool signed = false}) {
  final sign = signed && value > 0 ? '+' : '';
  return '$sign${formatNumber(value, fractionDigits: fractionDigits)}%';
}
