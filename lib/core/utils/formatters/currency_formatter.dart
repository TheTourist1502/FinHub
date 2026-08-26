import 'package:intl/intl.dart';

/// Formats [value] as a currency amount — e.g. `formatCurrency(1234.5)` →
/// `"$1,234.50"`, `formatCurrency(1234.5, currencyCode: 'EUR')` → `"€1,234.50"`.
///
/// [value] is a plain unit amount (dollars, not cents). [currencyCode] is an
/// ISO-4217 code; its conventional symbol is resolved by `intl` and falls back
/// to the code itself for currencies with no known symbol.
///
/// Always renders exactly [fractionDigits] decimal places so a column of
/// amounts aligns on the decimal point.
///
/// This is a **display** helper: it returns a [String] and must only be called
/// at the point of rendering. Domain models keep their raw [double] values so
/// comparison, sorting and arithmetic continue to work.
///
/// For large figures that need K/M/B abbreviation, use `compactDollar` from
/// `lib/core/utils/currency_utils.dart` instead.
String formatCurrency(num value, {String currencyCode = 'USD', int fractionDigits = 2}) => NumberFormat.currency(
  locale: 'en_US',
  symbol: NumberFormat.simpleCurrency(locale: 'en_US', name: currencyCode).currencySymbol,
  decimalDigits: fractionDigits,
).format(value);
