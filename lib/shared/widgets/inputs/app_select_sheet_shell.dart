import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field.dart';
import 'package:flutter/material.dart';

/// Container shell shared by the single- and multi-select bottom sheets.
///
/// Renders the drag handle, search field, optional [headerExtra] slot, the
/// scrollable [child] body and a bottom [actions] row.
class AppSelectSheetShell extends StatelessWidget {
  /// Builds the sheet chrome around a caller-supplied body and action row.
  const AppSelectSheetShell({
    required this.scrollController,
    required this.textController,
    required this.onQueryChanged,
    required this.child,
    required this.actions,
    super.key,
    this.headerExtra,
    this.searchLoading = false,
  });

  /// Controller driving the sheet's draggable scroll body.
  final ScrollController scrollController;

  /// Backing controller for the search [TextField].
  final TextEditingController textController;

  /// Called on every keystroke in the search field, and with `''` when the
  /// field's own clear button empties it.
  final ValueChanged<String> onQueryChanged;

  /// Scrollable body filling the space between header and actions.
  final Widget child;

  /// Bottom action row (e.g. Cancel / OK buttons).
  final Widget actions;

  /// Optional extra header content below the search field.
  final Widget? headerExtra;

  /// Whether a server-side search is still running for the current query;
  /// shows a spinner in the search field's clear-button slot.
  final bool searchLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.cardBorderRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: colors.bgOverlay.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            const SelectSheetDragHandle(),
            SelectSheetSearchField(
              controller: textController,
              onQueryChanged: onQueryChanged,
              loading: searchLoading,
            ),
            ?headerExtra,
            const SelectSheetHairline(),
            Expanded(child: child),
            const SelectSheetHairline(),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMd,
                  vertical: AppDimensions.spaceSm + 4,
                ),
                child: actions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The pill-shaped grab handle at the top of a select sheet.
class SelectSheetDragHandle extends StatelessWidget {
  /// Const so it never rebuilds with the sheet body.
  const SelectSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppDimensions.spaceSm + 4,
          bottom: AppDimensions.spaceSm,
        ),
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// Thin full-width rule separating the sheet's header, body and actions.
class SelectSheetHairline extends StatelessWidget {
  /// Const divider reused above and below the sheet body.
  const SelectSheetHairline({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.6),
    );
  }
}

/// Search input at the top of a select sheet.
///
/// Nothing but the sheet's own outer padding around an [AppSearchField], so a
/// picker's search reads the same as every other search box in the app.
class SelectSheetSearchField extends StatelessWidget {
  /// Wires a caller-owned controller to the sheet's query callback.
  const SelectSheetSearchField({
    required this.controller,
    required this.onQueryChanged,
    super.key,
    this.padding,
    this.hintText,
    this.loading = false,
  });

  /// Backing controller for the field's text.
  final TextEditingController controller;

  /// Called on every keystroke, and with `''` when cleared.
  final ValueChanged<String> onQueryChanged;

  /// Outer padding around the field. Defaults to [AppSelectSheetShell]'s own
  /// rhythm; sheets whose header uses a different cadence pass their own so
  /// the gap above and below the field matches their surrounding spacing.
  final EdgeInsetsGeometry? padding;

  /// Placeholder text. Defaults to the generic "search" hint; sheets that
  /// search over more than a label say what they match instead.
  final String? hintText;

  /// Whether the query behind the current text is still in flight; shows a
  /// spinner in place of the clear button.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ??
          const EdgeInsets.fromLTRB(
            AppDimensions.spaceMd,
            AppDimensions.spaceSx,
            AppDimensions.spaceMd,
            AppDimensions.spaceSm,
          ),
      child: AppSearchField(
        controller: controller,
        hintText: hintText ?? context.l10n.selectSearchHint,
        onChanged: onQueryChanged,
        loading: loading,
      ),
    );
  }
}
