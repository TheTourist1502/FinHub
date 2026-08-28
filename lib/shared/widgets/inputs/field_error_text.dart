import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

/// The inline validation message ("{field} is required !") drawn under a form
/// field, flush with the field's left edge.
///
/// Flutter insets `InputDecoration.errorText` by the decoration's content
/// padding plus the border's gap padding — roughly 21 px — so the built-in
/// message lines up with the *input text* rather than with the field. The
/// Account Maintenance and Online Access forms align every error at zero start
/// inset, so the message is rendered here instead of in the decoration.
///
/// A field that still wants the decoration's red border (and its error
/// semantics) keeps `errorText` set and hides the built-in line with
/// [kHiddenErrorStyle]; in that case pass `excludeSemantics: true` here so the
/// message is not announced twice.
class FieldErrorText extends StatelessWidget {
  /// Creates a [FieldErrorText].
  const FieldErrorText({required this.message, super.key, this.excludeSemantics = false});

  /// The localised message to show. Callers only build this widget when they
  /// have one, so it is non-null.
  final String message;

  /// Whether to keep the message out of the semantics tree because the field's
  /// own `errorText` already announces it.
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    final text = Padding(
      // Matches the 4 px gap the decoration puts between a field and its own
      // error line, so moving the message out here changes nothing vertically.
      padding: const EdgeInsets.only(top: AppDimensions.spaceSx),
      child: Text(
        message,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          height: 13 / 11,
          color: context.appColors.statusErrorDefault,
        ),
      ),
    );

    return excludeSemantics ? ExcludeSemantics(child: text) : text;
  }
}

/// Collapses `InputDecoration.errorText` to nothing.
///
/// A zero-size error line reports no height, so `InputDecorator` allocates no
/// subtext row at all — the field keeps its red error border and its error
/// semantics while [FieldErrorText] draws the message at zero start inset.
const TextStyle kHiddenErrorStyle = TextStyle(fontSize: 0, height: 0);
