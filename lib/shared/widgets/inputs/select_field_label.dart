import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Caption above a select trigger field, greyed out when the field is disabled.
///
/// Shared by [AppSingleSelect] and [AppMultiSelect] so both render their label
/// identically; pass [style] to override the default form-label typography,
/// and [required] to append the red `*` that marks a mandatory field.
class SelectFieldLabel extends StatelessWidget {
  /// Creates a [SelectFieldLabel] showing [text].
  const SelectFieldLabel({
    required this.text,
    required this.enabled,
    this.style,
    this.required = false,
    super.key,
  });

  /// Label caption rendered above the field.
  final String text;

  /// Whether the owning field accepts input; drives the greyed-out colour.
  final bool enabled;

  /// Whether to append a red `*` marking the field as mandatory. Defaults to
  /// `false` so existing selects render exactly as before.
  final bool required;

  /// Optional override for the default [AppTypography.formLabel] styling.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolved =
        style ??
        AppTypography.formLabel.copyWith(
          color: enabled ? theme.colorScheme.onSurface : theme.disabledColor,
        );

    if (!required) return Text(text, style: resolved);

    // RichText rather than two Text widgets in a Row so the `*` stays glued to
    // the label and wraps with it instead of being pushed onto its own line.
    return RichText(
      text: TextSpan(
        style: resolved,
        children: [
          TextSpan(text: text),
          TextSpan(
            text: ' *',
            style: TextStyle(color: context.appColors.statusErrorDefault),
          ),
        ],
      ),
    );
  }
}
