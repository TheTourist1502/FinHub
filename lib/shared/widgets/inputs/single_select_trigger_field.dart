import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/shared/widgets/inputs/app_select_input_decoration.dart';
import 'package:finhub/shared/widgets/inputs/field_error_text.dart';
import 'package:finhub/shared/widgets/inputs/select_sheet_toggle.dart';
import 'package:flutter/material.dart';

/// The tappable, decorated field that opens the single-select sheet.
///
/// Shows the selected label or the hint; a separate widget so validator
/// rebuilds don't touch the surrounding form layout.
class SingleSelectTriggerField extends StatelessWidget {
  /// Not part of the public API — constructed only by `AppSingleSelect`.
  const SingleSelectTriggerField({
    required this.enabled,
    required this.loading,
    required this.onTap,
    super.key,
    this.selectedLabel,
    this.hint,
    this.errorText,
    this.hintStyle,
    this.textStyle,
  });

  /// Whether the field accepts interaction and renders in full colour.
  final bool enabled;

  /// Whether to show a spinner in place of the chevron.
  final bool loading;

  /// Opens the option sheet; completes when the sheet closes, which is what
  /// drives the chevron back down.
  final Future<void> Function() onTap;

  /// Label of the current selection, or `null` when nothing is selected.
  final String? selectedLabel;

  /// Placeholder shown when [selectedLabel] is `null`.
  final String? hint;

  /// Validation message rendered under the field.
  final String? errorText;

  /// Caller override for the hint's metrics; its colour is always ignored.
  final TextStyle? hintStyle;

  /// Caller override for the selected label's style.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectSheetToggle(
          onTap: onTap,
          builder: (context, expanded, handleTap) => GestureDetector(
            onTap: handleTap,
            child: InputDecorator(
              decoration: appSelectInputDecoration(
                context: context,
                enabled: enabled,
                loading: loading,
                colors: colors,
                errorText: errorText,
                expanded: expanded,
              ),
              child: Text(
                selectedLabel ?? hint ?? '',
                style: selectedLabel != null
                    // A caller-supplied colour applies only while enabled —
                    // a disabled field always greys out.
                    ? (textStyle ?? AppTypography.bodyMedium).copyWith(
                        color: enabled ? (textStyle?.color ?? theme.colorScheme.onSurface) : theme.disabledColor,
                      )
                    : (hintStyle ?? AppTypography.inputHint).copyWith(color: colors.inputHintColor),
              ),
            ),
          ),
        ),
        // Drawn outside the decoration so it starts at the field's left edge
        // rather than at the content padding. See [FieldErrorText].
        if (errorText case final error?) FieldErrorText(message: error, excludeSemantics: true),
      ],
    );
  }
}
