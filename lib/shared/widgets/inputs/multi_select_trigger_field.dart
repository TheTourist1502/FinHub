import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/shared/widgets/inputs/app_select_input_decoration.dart';
import 'package:finhub/shared/widgets/inputs/field_error_text.dart';
import 'package:finhub/shared/widgets/inputs/select_sheet_toggle.dart';
import 'package:flutter/material.dart';

/// The tappable, decorated field that opens the multi-select sheet.
///
/// A widget rather than a `FormField` builder closure, so validator rebuilds
/// don't touch the surrounding form layout.
class MultiSelectTriggerField extends StatelessWidget {
  /// Not part of the public API — constructed only by `AppMultiSelect`.
  const MultiSelectTriggerField({
    required this.enabled,
    required this.onTap,
    required this.display,
    super.key,
    this.hint,
    this.errorText,
  });

  /// Whether the field renders in full colour.
  final bool enabled;

  /// Opens the option sheet; completes when the sheet closes, which is what
  /// drives the chevron back down.
  final Future<void> Function() onTap;

  /// Resolved summary of the current selection; empty shows [hint].
  final String display;

  /// Placeholder shown when nothing is selected.
  final String? hint;

  /// Validation message rendered under the field.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final hasValue = display.isNotEmpty;

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
                colors: colors,
                errorText: errorText,
                expanded: expanded,
              ),
              child: Text(
                hasValue ? display : (hint ?? ''),
                style: hasValue
                    ? AppTypography.inputText.copyWith(
                        color: enabled ? theme.colorScheme.onSurface : theme.disabledColor,
                      )
                    : AppTypography.inputHint.copyWith(color: colors.inputHintColor),
                overflow: TextOverflow.ellipsis,
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
