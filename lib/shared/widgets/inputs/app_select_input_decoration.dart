import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/shared/widgets/inputs/field_error_text.dart';
import 'package:flutter/material.dart';

/// Common [InputDecoration] for the single- and multi-select trigger fields.
///
/// Mirrors the app's global `InputDecorationTheme` so select fields look
/// identical to text fields. [colors] must come from `context.appColors`.
/// Set [expanded] while the field's sheet is open — see [SelectSheetToggle].
InputDecoration appSelectInputDecoration({
  required BuildContext context,
  required bool enabled,
  required AppColorTokens colors,
  String? errorText,
  bool loading = false,
  bool expanded = false,
}) {
  final theme = Theme.of(context);
  final fill = theme.inputDecorationTheme.fillColor ?? colors.surfaceDefault;
  final borderColor = theme.colorScheme.outlineVariant;
  final radius = BorderRadius.circular(AppDimensions.inputBorderRadius);

  return InputDecoration(
    filled: true,
    fillColor: enabled ? fill : colors.inputDisabledBg,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 17,
      vertical: 15,
    ),
    suffixIcon: loading
        ? Padding(
            padding: const EdgeInsets.all(14),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: enabled ? theme.colorScheme.onSurfaceVariant : theme.disabledColor,
              ),
            ),
          )
        : AnimatedRotation(
            // Half a turn: the chevron points up while the sheet is open and
            // falls back down as it closes.
            turns: expanded ? 0.5 : 0,
            duration: AppMotion.duration(context, AppMotion.quick),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: enabled ? theme.colorScheme.onSurfaceVariant : theme.disabledColor,
              size: 22,
            ),
          ),
    border: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.interactiveDefault, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.statusErrorDefault),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.statusErrorDefault, width: 1.5),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: theme.disabledColor.withValues(alpha: 0.3)),
    ),
    // [errorText] is kept only for the red border and the error semantics —
    // the message itself is drawn by `FieldErrorText` under the field, at zero
    // start inset, so the decoration's own indented line is collapsed away.
    errorText: errorText,
    errorStyle: kHiddenErrorStyle,
  );
}
