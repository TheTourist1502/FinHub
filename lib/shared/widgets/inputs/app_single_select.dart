import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/keyboard_dismiss.dart';
import 'package:finhub/shared/widgets/inputs/lazy_select_state.dart';
import 'package:finhub/shared/widgets/inputs/select_field_label.dart';
import 'package:finhub/shared/widgets/inputs/select_option.dart';
import 'package:finhub/shared/widgets/inputs/single_select_sheet.dart';
import 'package:finhub/shared/widgets/inputs/single_select_trigger_field.dart';
import 'package:flutter/material.dart';

export 'package:finhub/shared/widgets/inputs/app_select_input_decoration.dart' show appSelectInputDecoration;
export 'package:finhub/shared/widgets/inputs/app_select_sheet_shell.dart' show AppSelectSheetShell;
export 'package:finhub/shared/widgets/inputs/select_option.dart' show SelectOption;

/// A labelled input field that opens a **root-level draggable bottom sheet**
/// on tap, allowing the user to pick exactly one option.
///
/// Selecting an item closes the sheet immediately — no confirmation step.
/// The sheet appears **above** the app's [AppBar] and bottom tab bar because
/// it uses `useRootNavigator: true`.
///
/// ### Lazy loading
/// By default [options] is treated as the complete list and the sheet
/// filters it client-side as the user types. To back the sheet with a
/// paginated, server-searched list instead, pass [onLoadMore] and/or
/// [onSearchChanged]:
/// - [onLoadMore] fires once when the sheet's list is scrolled past 85%,
///   guarded by [hasMore] / [loadingMore] — call it from a Riverpod
///   notifier's `loadMore()` method.
/// - [onSearchChanged] fires ~400ms after the user stops typing, with local
///   filtering disabled — call it from a notifier method that re-fetches
///   [options] with a `search` query param.
/// In both cases the caller owns pagination/search state and simply passes
/// updated [options]/[hasMore]/[loadingMore] back in on rebuild; the widget
/// pushes those updates into the already-open sheet via internal
/// [ValueNotifier]s so it reacts live without the sheet itself depending on
/// Riverpod.
class AppSingleSelect<T> extends StatefulWidget {
  /// Creates a single-select field; see the class docs for lazy-loading use.
  const AppSingleSelect({
    required this.label,
    required this.options,
    this.hint,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.allowClear = false,
    this.loading = false,
    this.required = false,
    this.errorText,
    this.validator,
    this.hasMore = false,
    this.loadingMore = false,
    this.onLoadMore,
    this.onSearchChanged,
    this.displayLabel = true,
    this.labelStyle,
    this.hintStyle,
    this.textStyle,
    super.key,
  });

  /// Text shown above the field.
  final String label;

  /// Options offered in the sheet.
  final List<SelectOption<T>> options;

  /// Placeholder shown while nothing is selected.
  final String? hint;

  /// Currently selected value; the field is fully controlled by the caller.
  final T? value;

  /// Called with the newly picked value when the sheet closes.
  final ValueChanged<T?>? onChanged;

  /// Whether the field accepts interaction.
  final bool enabled;

  /// Whether the sheet offers a Clear button beside Cancel.
  ///
  /// The button only appears while [value] is non-null — there is nothing to
  /// clear otherwise. Tapping it calls [onChanged] with `null`, so only enable
  /// it on optional fields whose callback tolerates a null selection.
  final bool allowClear;

  /// Whether the label carries a red `*` marking the field as mandatory.
  ///
  /// Purely a label affordance — it does not itself validate anything. Drive
  /// the message with [errorText] (or [validator] inside a [Form]).
  final bool required;

  /// Caller-driven validation message shown under the trigger field.
  ///
  /// Takes precedence over anything [validator] produces, so a form that owns
  /// its own validation state — as the Account Maintenance form does, having
  /// no [Form] ancestor to call `validate()` — can surface an error without
  /// going through [FormField].
  final String? errorText;

  /// Whether the [label] is rendered above the field. Set to `false` when the
  /// surrounding layout already names the field; [label] is still required for
  /// accessibility and stays available to the sheet.
  final bool displayLabel;

  /// Overrides the default [label] text style. Leave `null` to use the
  /// standard [AppTypography.formLabel] styling (enabled/disabled aware).
  final TextStyle? labelStyle;

  /// Overrides the default [hint] text style shown when nothing is selected.
  /// Leave `null` to use the standard [AppTypography.inputHint] styling.
  ///
  /// Only metrics (size, weight, spacing) are honoured — the colour is always
  /// forced to `context.appColors.inputHintColor` so every hint in the app
  /// renders in the same colour.
  final TextStyle? hintStyle;

  /// Overrides the style of the **selected** option's label in the trigger
  /// field. Leave `null` to use the standard [AppTypography.bodyMedium]
  /// styling.
  ///
  /// Pass this alongside [hintStyle] to keep a filled field the same size as
  /// an empty one. A disabled field always greys out regardless of the
  /// colour set here.
  final TextStyle? textStyle;

  /// Whether options are still being fetched.
  ///
  /// Shows a spinner in place of the chevron and disables the field.
  final bool loading;

  /// Form validator run against the selected value.
  final String? Function(T?)? validator;

  /// Whether a subsequent page of [options] is available server-side.
  ///
  /// Ignored unless [onLoadMore] is set.
  final bool hasMore;

  /// Whether a pagination request is currently in flight.
  ///
  /// Shows a bottom loading row in the sheet's list. Ignored unless
  /// [onLoadMore] is set.
  final bool loadingMore;

  /// Called when the sheet's list is scrolled near its end and [hasMore] is
  /// `true`. Fetch the next page and pass the appended result back via
  /// [options]. Omit to disable pagination (the sheet then shows exactly
  /// [options] with no scroll-triggered fetch).
  final VoidCallback? onLoadMore;

  /// Called (debounced ~400ms) with the sheet's search text when it changes.
  ///
  /// When set, the sheet stops filtering [options] locally — pass the
  /// server-filtered result back via [options]. Omit to keep the default
  /// client-side label filter.
  final ValueChanged<String>? onSearchChanged;

  @override
  State<AppSingleSelect<T>> createState() => _AppSingleSelectState<T>();
}

class _AppSingleSelectState<T> extends State<AppSingleSelect<T>> {
  /// Lets [didUpdateWidget] push a new controlled value into [FormFieldState]
  /// so the validator never sees a stale selection.
  final _fieldKey = GlobalKey<FormFieldState<T>>();

  /// Cached result of the linear options scan, recomputed only when the
  /// value or option list changes rather than on every build.
  String? _cachedLabel;

  /// Live-updated while the sheet is open so pagination/search results reach
  /// the already-built sheet.
  late final ValueNotifier<LazySelectState<T>> _lazyState;

  @override
  void initState() {
    super.initState();
    _cachedLabel = _computeLabel();
    _lazyState = ValueNotifier(_buildLazyState());
  }

  @override
  void didUpdateWidget(AppSingleSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value || oldWidget.options != widget.options) {
      _cachedLabel = _computeLabel();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _fieldKey.currentState?.didChange(widget.value),
      );
    }
    if (oldWidget.options != widget.options ||
        oldWidget.hasMore != widget.hasMore ||
        oldWidget.loadingMore != widget.loadingMore) {
      // Deferred: assigning `.value` synchronously would notify the open
      // sheet's listener while an ancestor is still mid-build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _lazyState.value = _buildLazyState();
      });
    }
  }

  @override
  void dispose() {
    _lazyState.dispose();
    super.dispose();
  }

  LazySelectState<T> _buildLazyState() =>
      LazySelectState(options: widget.options, hasMore: widget.hasMore, loadingMore: widget.loadingMore);

  String? _computeLabel() {
    if (widget.value == null) return null;
    return widget.options.where((o) => o.value == widget.value).firstOrNull?.label;
  }

  /// Opens the picker sheet above the app chrome and reports the result.
  Future<void> _openSheet() async {
    // A text field elsewhere in the form may still hold focus; its keyboard
    // would sit over the sheet and be restored when the sheet closes.
    dismissKeyboard();
    final picked = await showModalBottomSheet<SingleSelectSheetResult<T>>(
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
      builder: (_) => SingleSelectSheet<T>(
        stateListenable: _lazyState,
        initialValue: widget.value,
        allowClear: widget.allowClear,
        onLoadMore: widget.onLoadMore,
        onSearchChanged: widget.onSearchChanged,
      ),
    );

    // A null result means cancelled/dismissed; a result holding a null value
    // means the user cleared the selection.
    if (picked != null && widget.onChanged != null) {
      widget.onChanged!(picked.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Loading forces the field into a disabled, non-interactive state.
    final isEnabled = widget.enabled && !widget.loading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.displayLabel) ...[
          SelectFieldLabel(
            text: widget.label,
            enabled: isEnabled,
            style: widget.labelStyle,
            required: widget.required,
          ),
          const SizedBox(height: AppDimensions.spaceSm),
        ],
        // IgnorePointer blocks touch to the entire subtree when disabled.
        IgnorePointer(
          ignoring: !isEnabled,
          child: FormField<T>(
            key: _fieldKey,
            initialValue: widget.value,
            validator: widget.validator,
            builder: (field) => SingleSelectTriggerField(
              enabled: isEnabled,
              loading: widget.loading,
              onTap: _openSheet,
              selectedLabel: _cachedLabel,
              hint: widget.hint,
              errorText: widget.errorText ?? field.errorText,
              hintStyle: widget.hintStyle,
              textStyle: widget.textStyle,
            ),
          ),
        ),
      ],
    );
  }
}
