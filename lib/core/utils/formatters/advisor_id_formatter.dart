/// Masks [advisorId] for display — e.g.
/// `formatMaskedAdvisorId('0054W00000DTeRmQAL')` → `"xxxxxxxxxxxxxxmQAL"`,
/// `formatMaskedAdvisorId('ABCDE')` → `"xBCDE"`.
///
/// Every character except the final four is replaced with a lowercase `x`, so
/// the result always has the same length as the input and the trailing four
/// characters are preserved verbatim. Salesforce advisor IDs are 18 characters,
/// but no length is assumed.
///
/// Edge cases (never throws — see below):
/// * An input of four characters or fewer is **fully masked** (`'12'` → `"xx"`).
///   Returning it as-is would expose the whole identifier, which is the exact
///   opposite of what a privacy-masking helper is for; when in doubt this
///   helper hides more, not less.
/// * An empty string returns an empty string — there is nothing to mask and an
///   empty label is the correct rendering of a missing ID.
///
/// This is a **display** helper: it returns a [String] and must only be called
/// at the point of rendering. Domain models keep the raw, unmasked ID so
/// lookups and API calls continue to work.
String formatMaskedAdvisorId(String advisorId) {
  if (advisorId.length <= 4) return 'x' * advisorId.length;
  final visible = advisorId.substring(advisorId.length - 4);
  return '${'x' * (advisorId.length - 4)}$visible';
}

/// Short masked form for tight chrome — two mask characters plus the final
/// [visible] characters of [advisorId], e.g.
/// `formatShortMaskedAdvisorId('0054W00000DTeRmQAL')` → `"XXAL"` and
/// `formatShortMaskedAdvisorId('0054W00000DTeRmQAL', visible: 4)` →
/// `"XXmQAL"`.
///
/// Masks with an uppercase `X`, unlike [formatMaskedAdvisorId]: this form is
/// set in all-caps chrome next to uppercase initials, where a lowercase `x`
/// reads as part of the ID rather than as redaction.
///
/// A fixed `2 + visible` characters wide regardless of input length, because
/// it is used where the layout cannot grow with the ID. [visible] defaults to
/// the narrowest useful tail; callers with room for more — a list row rather
/// than a header pill — raise it. Even at `visible: 4` it reveals no more than
/// [formatMaskedAdvisorId], so it stays safe anywhere that one is.
///
/// Edge cases mirror the full masker: an ID no longer than [visible] is fully
/// masked and an empty ID renders as an empty string.
String formatShortMaskedAdvisorId(String advisorId, {int visible = 2}) {
  if (advisorId.isEmpty) return '';
  if (advisorId.length <= visible) return 'X' * advisorId.length;
  return 'XX${advisorId.substring(advisorId.length - visible)}';
}
