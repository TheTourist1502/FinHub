import 'package:finhub/core/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Builds a text input from the [formatters] that enforce its length ceiling
/// and the [limitError] to show once that ceiling has turned a keystroke away.
///
/// [limitError] is already localised and is `null` whenever the advisor has
/// room left, so it can be handed straight to whatever error slot the field
/// renders — `InputDecoration.errorText` or a `Text` of its own.
typedef LengthLimitedInputBuilder =
    Widget Function(BuildContext context, List<TextInputFormatter> formatters, String? limitError);

/// Wraps a text input with a hard character limit.
///
/// Two things happen at [maxLength]: typing and pasting stop there — the value
/// can never grow past it — and the field starts reporting
/// `commonMaxLengthExceeded`, so the advisor learns *why* the keyboard went
/// dead instead of silently losing characters. The message clears as soon as
/// an edit is accepted again, which for a field sitting at its ceiling means
/// the first deletion.
///
/// The error is deliberately not gated behind the forms' `showErrors` flag:
/// unlike "this field is required", it answers a question the advisor is
/// asking *right now*, and waiting for Submit to answer it would be useless.
///
/// A value prefilled from the backend never passes through the formatters, so
/// it can still arrive over-long. Fields keep their `maxLengthErrorText` /
/// `requiredFieldErrorText` checks for that case — this widget is the typing
/// half of the rule, not a replacement for it.
class LengthLimitedInput extends StatefulWidget {
  /// Creates a [LengthLimitedInput].
  const LengthLimitedInput({
    required this.maxLength,
    required this.builder,
    this.extraFormatters = const [],
    super.key,
  });

  /// The hard ceiling, in characters.
  final int maxLength;

  /// Formatters applied *before* the length limit — digit filters and the
  /// like, which must run first so that what they strip does not count
  /// towards [maxLength].
  final List<TextInputFormatter> extraFormatters;

  /// Builds the field itself. See [LengthLimitedInputBuilder].
  final LengthLimitedInputBuilder builder;

  @override
  State<LengthLimitedInput> createState() => _LengthLimitedInputState();
}

/// Tracks whether the last edit was cut short by the limit.
///
/// This is ephemeral input state that exists only between two keystrokes and
/// is read by nothing outside the field, so it is held here rather than in a
/// provider — the same reason the dial-code sheet keeps its search query
/// locally.
class _LengthLimitedInputState extends State<LengthLimitedInput> {
  bool _limitReached = false;

  /// Records whether [rejected] characters were dropped by the limit,
  /// rebuilding only when the answer changes.
  void _setLimitReached({required bool rejected}) {
    if (_limitReached == rejected) return;
    setState(() => _limitReached = rejected);
  }

  @override
  Widget build(BuildContext context) {
    final formatters = [
      ...widget.extraFormatters,
      _ReportingLengthLimitingFormatter(widget.maxLength, onLimitReached: _setLimitReached),
    ];
    final limitError = _limitReached ? context.l10n.commonMaxLengthExceeded(widget.maxLength) : null;

    return widget.builder(context, formatters, limitError);
  }
}

/// A [LengthLimitingTextInputFormatter] that reports whether it had to
/// truncate, so the field above it can say so.
///
/// Truncation is detected by comparing the formatter's own output with the
/// value it was handed rather than by measuring against `maxLength` directly:
/// the base class truncates by grapheme cluster, and an emoji or accented
/// character must count the same way there as it does here.
class _ReportingLengthLimitingFormatter extends LengthLimitingTextInputFormatter {
  /// Creates a [_ReportingLengthLimitingFormatter].
  _ReportingLengthLimitingFormatter(super.maxLength, {required this.onLimitReached});

  /// Called after every edit with whether that edit lost characters.
  final void Function({required bool rejected}) onLimitReached;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final formatted = super.formatEditUpdate(oldValue, newValue);
    onLimitReached(rejected: formatted.text.length != newValue.text.length);
    return formatted;
  }
}
