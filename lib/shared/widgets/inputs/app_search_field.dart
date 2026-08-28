import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_theme.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// The app-wide search box.
///
/// Every screen that filters a list uses this widget, so the control looks and
/// behaves identically everywhere: magnify prefix, 12 px rounded border, and a
/// clear ("x") button that appears as soon as the field holds text. The visual
/// style lives in [AppTheme.searchDecoration] — never rebuild it at a call
/// site.
///
/// The clear button is always available: the field falls back to a controller
/// of its own when the caller has no use for one, so any search box holding
/// text can be emptied. Clearing empties the field and re-notifies [onChanged]
/// with `''`, so callers only supply extra work (dropping focus, resetting a
/// provider) via [onClear].
///
/// While the first page of data is in flight, show [AppSearchFieldShimmer]
/// in this widget's place rather than a disabled field.
class AppSearchField extends StatefulWidget {
  /// Creates an [AppSearchField].
  const AppSearchField({
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onClear,
    this.focusNode,
    this.enabled = true,
    this.autofocus = false,
    this.loading = false,
    super.key,
  });

  /// Placeholder shown while the field is empty.
  final String hintText;

  /// Controller owned by the caller — pass one to seed or read the query.
  ///
  /// Callers that only need the keystrokes can leave this `null`; the field
  /// then creates and disposes a controller of its own so the clear button
  /// still works.
  final TextEditingController? controller;

  /// Called on every keystroke, and again with `''` when the field is cleared.
  final ValueChanged<String>? onChanged;

  /// Extra work to run when the clear button is tapped.
  ///
  /// The field and [onChanged] are already handled — use this only for side
  /// effects such as unfocusing or resetting a provider the field does not own.
  final VoidCallback? onClear;

  /// Optional focus node, e.g. to focus the field on mount.
  final FocusNode? focusNode;

  /// Whether the field accepts input; `false` when there is nothing to search.
  final bool enabled;

  /// Whether the field takes focus as soon as it is mounted.
  final bool autofocus;

  /// Whether a server-side search for the current text is still running.
  ///
  /// Swaps the clear button for a spinner until the results land, so the
  /// advisor can tell a slow query from an empty result. Only meaningful for
  /// server-driven search — a local filter is instant.
  final bool loading;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  /// Controller created only when the caller supplied none; the caller's own
  /// controller is never disposed here, since this widget does not own it.
  TextEditingController? _fallbackController;

  /// The controller actually driving the field.
  TextEditingController get _controller => widget.controller ?? (_fallbackController ??= TextEditingController());

  @override
  void dispose() {
    _fallbackController?.dispose();
    super.dispose();
  }

  /// Empties the field, notifies `onChanged`, then runs the caller's `onClear`.
  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      textInputAction: TextInputAction.search,
      style: AppTypography.searchText.copyWith(color: context.appColors.textPrimary),
      decoration: AppTheme.searchDecoration(
        context,
        hint: widget.hintText,
        // The clear button watches the controller itself, so a keystroke
        // repaints only the suffix instead of rebuilding the decoration.
        suffixIcon: _ClearButton(controller: _controller, onClear: _handleClear, loading: widget.loading),
      ),
    );
  }
}

/// Clear icon shown only while [controller] holds text — a spinner in its
/// place while [loading].
class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.controller, required this.onClear, required this.loading});

  /// Controller whose text decides whether the button is visible.
  final TextEditingController controller;

  /// Invoked when the button is tapped.
  final VoidCallback onClear;

  /// Whether the query behind the current text is still in flight.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) => value.text.isEmpty ? const SizedBox.shrink() : child!,
      // Built once and reused across every notification.
      child: loading
          // Same footprint as the button it replaces, so the field's content
          // does not shift as the query resolves.
          ? SizedBox(
              width: 41,
              height: 44,
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: context.appColors.textDisabled),
                ),
              ),
            )
          : IconButton(
              onPressed: onClear,
              tooltip: context.l10n.commonSearchClear,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 41, minHeight: 44),
              icon: Iconify(Mdi.close, color: context.appColors.textDisabled, size: 18),
            ),
    );
  }
}
