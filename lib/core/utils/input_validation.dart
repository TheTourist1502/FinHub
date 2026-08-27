import 'package:finhub/core/config/app_constants.dart';
import 'package:finhub/generated/l10n/app_localizations.dart';

/// Pragmatic email shape check: a non-empty local part, an `@`, and a domain
/// carrying at least one dot with a 2+ character final label.
///
/// Deliberately *not* the full RFC 5322 grammar — that grammar accepts
/// addresses (quoted local parts, IP-literal domains, comments) that no
/// advisor will ever type here and that Salesforce rejects downstream anyway.
/// The backend remains the authority; this only stops the obvious typo before
/// a round-trip.
final RegExp _emailPattern = RegExp(
  r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$",
);

/// Whether [value] both looks like an email address and fits within
/// [maxLength], which defaults to the [AppConstants.maxEmailLength] protocol
/// ceiling. Fields backed by a narrower record pass their own limit.
///
/// A blank [value] is *not* valid — callers that treat empty as "not filled in
/// yet" (so no error is shown while typing has not started) check emptiness
/// themselves; see [emailErrorText].
bool isValidEmail(String value, {int maxLength = AppConstants.maxEmailLength}) {
  final trimmed = value.trim();
  return trimmed.length <= maxLength && _emailPattern.hasMatch(trimmed);
}

/// Whether [value] fits within [maxLength], which defaults to the
/// app-wide [AppConstants.maxInputFieldLength]. Fields with a tighter limit of
/// their own pass it explicitly.
bool isWithinInputLimit(String value, {int maxLength = AppConstants.maxInputFieldLength}) => value.length <= maxLength;

/// A subscriber mobile number: digits only, between
/// [AppConstants.minMobileNumberLength] and
/// [AppConstants.maxMobileNumberLength] of them.
///
/// The country dial code is picked separately and is never part of the value
/// this matches, so no leading `+` or country prefix is permitted here.
final RegExp _mobileNumberPattern = RegExp(
  '^[0-9]{${AppConstants.minMobileNumberLength},${AppConstants.maxMobileNumberLength}}\$',
);

/// Strips every non-digit from [value].
///
/// Used to normalise a number arriving from the backend, which may carry
/// display formatting (`(201) 555-0123`) that the field itself no longer
/// accepts — see [isValidMobileNumber].
String digitsOnly(String value) => value.replaceAll(RegExp('[^0-9]'), '');

/// Whether [value] is a valid subscriber mobile number.
///
/// A blank [value] is *not* valid — callers that treat empty as "not filled in
/// yet" check emptiness themselves; see [mobileNumberErrorText].
bool isValidMobileNumber(String value) => _mobileNumberPattern.hasMatch(value.trim());

/// The error to show under a mobile number field, or `null` when there is
/// nothing to complain about.
///
/// Returns `null` for a blank field for the same reason [emailErrorText] does:
/// an untouched input must never render red.
///
/// One message covers "too short", "too long" and "not digits" alike, because
/// it states the rule rather than the specific breach — and with the field's
/// own input formatters in place, too-long and non-digit values can only ever
/// reach here from prefilled backend data, not from typing.
String? mobileNumberErrorText(String value, AppLocalizations l10n) {
  if (value.trim().isEmpty) return null;
  return isValidMobileNumber(value)
      ? null
      : l10n.commonInvalidMobileNumber(AppConstants.minMobileNumberLength, AppConstants.maxMobileNumberLength);
}

/// The error to show under an email field, or `null` when there is nothing to
/// complain about.
///
/// Returns `null` for a blank field so an untouched input never renders red —
/// "this is required" is communicated by the label's `*` and by the submit
/// button staying disabled, not by an error message.
///
/// [maxLength] must match whatever the caller passes to [isValidEmail], or the
/// field and the submit button will disagree about the same value.
String? emailErrorText(String value, AppLocalizations l10n, {int maxLength = AppConstants.maxEmailLength}) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  if (trimmed.length > maxLength) return l10n.commonMaxLengthExceeded(maxLength);
  return _emailPattern.hasMatch(trimmed) ? null : l10n.commonInvalidEmail;
}

/// A postal code: an alphanumeric first character followed by further letters,
/// digits, spaces or hyphens, between [AppConstants.minPostalCodeLength] and
/// [AppConstants.maxPostalCodeLength] characters in total.
///
/// Deliberately country-agnostic. The address form accepts addresses
/// worldwide, so this rules out only the shapes no postal system uses (too
/// short or too long, a leading separator, symbols) rather than matching any
/// one country's grammar.
final RegExp _postalCodePattern = RegExp(
  '^[A-Za-z0-9][A-Za-z0-9 -]'
  '{${AppConstants.minPostalCodeLength - 1},${AppConstants.maxPostalCodeLength - 1}}\$',
);

/// Whether [value] has a plausible postal code shape.
///
/// A blank [value] is *not* valid — callers that treat empty as "not filled in
/// yet" check emptiness themselves; see [postalCodeErrorText].
bool isValidPostalCode(String value) => _postalCodePattern.hasMatch(value.trim());

/// The error to show under a postal code field, or `null` when there is
/// nothing to complain about.
///
/// Returns `null` for a blank field, like [emailErrorText] does: a Postal Code
/// is only mandatory in some countries, and where it is, the "this is missing"
/// message comes from [requiredFieldErrorText] instead.
String? postalCodeErrorText(String value, AppLocalizations l10n) {
  if (value.trim().isEmpty) return null;
  return isValidPostalCode(value) ? null : l10n.commonInvalidPostalCode;
}

/// The error to show under a free-text field that has run past [maxLength], or
/// `null` while it is within limit.
///
/// [maxLength] must match whatever the caller passes to [isWithinInputLimit],
/// or the field and the submit button will disagree about the same value.
String? maxLengthErrorText(String value, AppLocalizations l10n, {int maxLength = AppConstants.maxInputFieldLength}) =>
    isWithinInputLimit(value, maxLength: maxLength) ? null : l10n.commonMaxLengthExceeded(maxLength);

/// The error to show under a **required** free-text field: names [fieldLabel]
/// as missing while blank, otherwise falls through to the [maxLengthErrorText]
/// check.
///
/// Unlike [maxLengthErrorText], [emailErrorText] and [mobileNumberErrorText] —
/// which all stay silent on a blank field so an untouched input never renders
/// red — this one reports emptiness, for forms that mark required fields with
/// a `*` and are expected to say *which* one is missing rather than leaving
/// the advisor to hunt for it behind a disabled submit button.
///
/// [fieldLabel] must be the already-translated label the field renders, so the
/// message matches what the advisor is looking at.
String? requiredFieldErrorText(
  String value,
  String fieldLabel,
  AppLocalizations l10n, {
  int maxLength = AppConstants.maxInputFieldLength,
}) => value.trim().isEmpty
    ? l10n.validationFieldRequired(fieldLabel)
    : maxLengthErrorText(value, l10n, maxLength: maxLength);
