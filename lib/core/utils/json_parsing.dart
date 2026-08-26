/// Null-tolerant coercion helpers for backend JSON fields.
///
/// The backend is inconsistent about the shape of a given field across rows
/// and across endpoints, so every model parses through these helpers rather
/// than casting.
///
/// **Numeric fields may arrive as JSON strings.** To avoid precision loss on
/// the wire, monetary and quantity values (`marketValueCents`, `totalAumCents`,
/// `totalCommissionCents`, `quantity`, `aumChangePercentage`, …) are serialised
/// as strings such as `"37.0000"`. A hard cast (`json['x'] as num`) crashes the
/// whole list the moment one of them does. [parseNum] and [parseInt] accept
/// either shape, so use them for **every** numeric field — never a cast, and
/// never `double.parse`, which fails in the opposite direction when the backend
/// sends a bare number.
///
/// Note on the `Cents` suffix: monetary keys are named `*Cents`
/// (`totalAumCents`, `unitPriceCents`) but the backend sends **dollar**
/// amounts, not integer cents. Parse them with [parseNum] as-is — never
/// divide by 100.
library;

/// Parses a numeric field that may arrive as a [num], a numeric [String]
/// (e.g. `"37.0000"`), or `null`.
///
/// Returns `0` when the value is absent or not parseable as a number.
double parseNum(dynamic value) => switch (value) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s) ?? 0,
  _ => 0,
};

/// Parses an integer field that may arrive as a [num], a numeric [String]
/// (e.g. `"12"`, `"12.0"`), or `null`.
///
/// Returns [fallback] (`0` by default) when the value is absent or not
/// parseable. A fractional value truncates toward zero, matching the `as int`
/// / `.toInt()` behaviour this replaces.
int parseInt(dynamic value, {int fallback = 0}) => switch (value) {
  final num n => n.toInt(),
  final String s => int.tryParse(s) ?? double.tryParse(s)?.toInt() ?? fallback,
  _ => fallback,
};

/// Parses an integer field that may be absent, returning `null` rather than a
/// fallback so callers can distinguish "not sent" from "sent as zero".
int? parseOptionalInt(dynamic value) => switch (value) {
  final num n => n.toInt(),
  final String s => int.tryParse(s) ?? double.tryParse(s)?.toInt(),
  _ => null,
};

/// Parses a string field that may be absent or `null`.
///
/// Returns `null` rather than an empty string so callers can distinguish
/// "the backend sent nothing" from "the backend sent an empty value".
String? parseOptionalString(dynamic value) => value is String ? value : null;

/// Parses a string field that may be absent or `null`, collapsing both to
/// [fallback] (an empty string by default).
String parseString(dynamic value, {String fallback = ''}) => value is String ? value : fallback;

/// Parses an ISO-8601 timestamp that may be absent, `null`, or malformed.
///
/// Returns `null` instead of throwing so one bad row cannot fail the whole
/// response. The result keeps the UTC offset the backend sent — convert for
/// display with `DateFormat.formatLocal()`, never here.
DateTime? parseOptionalDateTime(dynamic value) => value is String ? DateTime.tryParse(value) : null;

/// Parses a required ISO-8601 timestamp, falling back to the Unix epoch when
/// the value is absent or malformed.
///
/// Used for fields the UI always renders (e.g. a trade date), where a null
/// would force every call site into a null check for a case the backend does
/// not actually produce.
DateTime parseDateTime(dynamic value) =>
    parseOptionalDateTime(value) ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
