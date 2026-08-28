import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/utils/keyboard_dismiss.dart';
import 'package:finhub/shared/widgets/inputs/multi_select_sheet.dart';
import 'package:finhub/shared/widgets/inputs/multi_select_trigger_field.dart';
import 'package:finhub/shared/widgets/inputs/select_field_label.dart';
import 'package:finhub/shared/widgets/inputs/select_option.dart';
import 'package:flutter/material.dart';

/// A labelled input field that opens a **root-level draggable bottom sheet**
/// on tap, allowing the user to pick **one or more** options via styled
/// checkbox rows.
///
/// The sheet appears **above** the app's [AppBar] and bottom tab bar because
/// it uses `useRootNavigator: true`.
class AppMultiSelect<T> extends StatefulWidget {
  /// Creates a multi-select field; the caller owns [values].
  const AppMultiSelect({
    required this.label,
    required this.options,
    this.hint,
    this.values = const [],
    this.onChanged,
    this.maxSelectedLabel,
    this.enabled = true,
    this.validator,
    super.key,
  });

  /// Text shown above the field.
  final String label;

  /// Options offered in the sheet.
  final List<SelectOption<T>> options;

  /// Placeholder shown while nothing is selected.
  final String? hint;

  /// Currently selected values; the field is fully controlled by the caller.
  final List<T> values;

  /// Called with the confirmed values when the sheet closes.
  final ValueChanged<List<T>>? onChanged;

  /// When selected count exceeds this, shows "N selected" in the trigger.
  final int? maxSelectedLabel;

  /// Whether the field accepts interaction.
  final bool enabled;

  /// Form validator run against the selected values.
  final String? Function(List<T>?)? validator;

  @override
  State<AppMultiSelect<T>> createState() => _AppMultiSelectState<T>();
}

class _AppMultiSelectState<T> extends State<AppMultiSelect<T>> {
  /// Lets [didUpdateWidget] push new controlled values into [FormFieldState]
  /// so the validator never sees a stale selection.
  final _fieldKey = GlobalKey<FormFieldState<List<T>>>();

  /// Cached trigger text, recomputed only when the inputs change rather than
  /// on every build. `null` means "render the localised N-selected label".
  String? _cachedDisplay = '';

  @override
  void initState() {
    super.initState();
    _cachedDisplay = _computeDisplay();
  }

  @override
  void didUpdateWidget(AppMultiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values ||
        oldWidget.options != widget.options ||
        oldWidget.maxSelectedLabel != widget.maxSelectedLabel) {
      _cachedDisplay = _computeDisplay();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _fieldKey.currentState?.didChange(widget.values),
      );
    }
  }

  /// Joins the selected labels, or returns `null` once the count passes
  /// [AppMultiSelect.maxSelectedLabel] — l10n is only reachable from `build`.
  String? _computeDisplay() {
    if (widget.values.isEmpty) return '';
    final max = widget.maxSelectedLabel;
    if (max != null && widget.values.length > max) return null;
    final valSet = Set<T>.from(widget.values);
    return widget.options.where((o) => valSet.contains(o.value)).map((o) => o.label).join(', ');
  }

  /// Opens the picker sheet above the app chrome and reports the result.
  Future<void> _openSheet() async {
    // A text field elsewhere in the form may still hold focus; its keyboard
    // would sit over the sheet and be restored when the sheet closes.
    dismissKeyboard();
    final picked = await showModalBottomSheet<List<T>>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: const AnimationStyle(
        curve: Curves.linear,
        reverseCurve: Curves.linear,
        duration: Duration(milliseconds: 280),
        reverseDuration: Duration(milliseconds: 220),
      ),
      builder: (_) => MultiSelectSheet<T>(
        options: widget.options,
        initialValues: List<T>.from(widget.values),
      ),
    );

    if (picked != null && widget.onChanged != null) {
      widget.onChanged!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final display = _cachedDisplay ?? context.l10n.selectNSelected(widget.values.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectFieldLabel(text: widget.label, enabled: widget.enabled),
        const SizedBox(height: AppDimensions.spaceSm),
        // IgnorePointer blocks touch to the entire subtree when disabled.
        IgnorePointer(
          ignoring: !widget.enabled,
          child: FormField<List<T>>(
            key: _fieldKey,
            initialValue: widget.values,
            validator: widget.validator,
            builder: (field) => MultiSelectTriggerField(
              enabled: widget.enabled,
              onTap: _openSheet,
              display: display,
              hint: widget.hint,
              errorText: field.errorText,
            ),
          ),
        ),
      ],
    );
  }
}
