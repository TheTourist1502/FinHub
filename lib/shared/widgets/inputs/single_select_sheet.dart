import 'dart:async';

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/shared/widgets/inputs/app_select_sheet_shell.dart';
import 'package:finhub/shared/widgets/inputs/lazy_select_state.dart';
import 'package:finhub/shared/widgets/inputs/select_option.dart';
import 'package:finhub/shared/widgets/inputs/single_select_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Outcome of a [SingleSelectSheet], distinguishing "cleared" from
/// "dismissed".
///
/// The sheet cannot signal a clear by popping `null`, since that is also what
/// a barrier tap or Cancel produces. Popping this wrapper instead makes the
/// two cases distinct: a `null` route result means the selection is untouched,
/// while a result carrying a `null` [value] means the user cleared it.
@immutable
class SingleSelectSheetResult<T> {
  /// Wraps the value the sheet resolved to — `null` when it was cleared.
  const SingleSelectSheetResult(this.value);

  /// The picked value, or `null` if the user tapped Clear.
  final T? value;
}

/// Internal bottom sheet for `AppSingleSelect`.
///
/// Listens to [stateListenable] so options streamed in by pagination or
/// server search reach it while it is already open.
class SingleSelectSheet<T> extends StatefulWidget {
  /// Not part of the public API — constructed only by `AppSingleSelect`.
  const SingleSelectSheet({
    required this.stateListenable,
    required this.initialValue,
    super.key,
    this.allowClear = false,
    this.onLoadMore,
    this.onSearchChanged,
  });

  /// Whether a Clear button sits beside Cancel while [initialValue] is set.
  final bool allowClear;

  /// Live options plus pagination flags owned by the parent field.
  final ValueListenable<LazySelectState<T>> stateListenable;

  /// Value highlighted when the sheet opens.
  final T? initialValue;

  /// Called when the list is scrolled near its end and more pages exist.
  final VoidCallback? onLoadMore;

  /// When set, search is server-driven and debounced instead of local.
  final ValueChanged<String>? onSearchChanged;

  @override
  State<SingleSelectSheet<T>> createState() => _SingleSelectSheetState<T>();
}

class _SingleSelectSheetState<T> extends State<SingleSelectSheet<T>> {
  static const _searchDebounce = Duration(milliseconds: 400);
  static const _loadMoreThreshold = 0.85;

  String _query = '';
  final TextEditingController _textController = TextEditingController();
  Timer? _debounce;

  List<SelectOption<T>>? _cachedFiltered;
  String? _lastQuery;
  List<SelectOption<T>>? _lastOptions;

  /// When set, search is server-driven — local label filtering is disabled
  /// and [SingleSelectSheet.onSearchChanged] is called (debounced) instead.
  bool get _isServerSearch => widget.onSearchChanged != null;

  @override
  void dispose() {
    _textController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() => _query = value);
    if (!_isServerSearch) return;
    _debounce?.cancel();
    _debounce = Timer(_searchDebounce, () => widget.onSearchChanged!(value));
  }

  /// Filters [options] by label, memoised on query *and* list identity so an
  /// appended page invalidates the cache even when the query is unchanged.
  List<SelectOption<T>> _filtered(List<SelectOption<T>> options) {
    if (_isServerSearch) return options;
    if (_lastQuery == _query && _lastOptions == options && _cachedFiltered != null) return _cachedFiltered!;
    _lastQuery = _query;
    _lastOptions = options;
    _cachedFiltered = _query.isEmpty
        ? options
        : options.where((o) => o.label.toLowerCase().contains(_query.toLowerCase())).toList();
    return _cachedFiltered!;
  }

  /// Fires `onLoadMore` past [_loadMoreThreshold]; duplicate/in-flight
  /// guarding is the caller's responsibility.
  bool _onScrollNotification(ScrollNotification notification) {
    if (widget.onLoadMore == null) return false;
    final metrics = notification.metrics;
    if (metrics.maxScrollExtent == 0) return false;
    if (metrics.pixels >= metrics.maxScrollExtent * _loadMoreThreshold) {
      widget.onLoadMore!();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      expand: false,
      snap: true,
      snapSizes: const [0.5, 0.75, 0.95],
      builder: (ctx, scrollController) {
        return ValueListenableBuilder<LazySelectState<T>>(
          valueListenable: widget.stateListenable,
          builder: (context, lazyState, _) {
            return AppSelectSheetShell(
              scrollController: scrollController,
              textController: _textController,
              onQueryChanged: _onQueryChanged,
              // Spans the debounce window too, so the spinner appears on the
              // keystroke rather than 400ms later when the request goes out.
              searchLoading: _isServerSearch && ((_debounce?.isActive ?? false) || lazyState.loadingMore),
              actions: _SheetActions(
                // Clearing is only offered once there is something to clear.
                onClear: widget.allowClear && widget.initialValue != null
                    ? () => Navigator.of(context).pop(SingleSelectSheetResult<T>(null))
                    : null,
                onCancel: () => Navigator.of(context).pop(),
              ),
              child: SingleSelectList<T>(
                scrollController: scrollController,
                options: _filtered(lazyState.options),
                selectedValue: widget.initialValue,
                showLoadingFooter: widget.onLoadMore != null && lazyState.loadingMore,
                onSelected: (value) => Navigator.of(context).pop(SingleSelectSheetResult<T>(value)),
                onScrollNotification: _onScrollNotification,
              ),
            );
          },
        );
      },
    );
  }
}

/// Bottom action row — Cancel alone, or Clear beside it when [onClear] is set.
///
/// Confirming stays implicit (tap an option), so neither button commits a
/// selection.
class _SheetActions extends StatelessWidget {
  const _SheetActions({required this.onCancel, this.onClear});

  /// Closes the sheet leaving the current selection untouched.
  final VoidCallback onCancel;

  /// Closes the sheet resolving to no selection. Null hides the button.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final cancel = SizedBox(
      width: double.infinity,
      child: FilledButton.tonal(
        onPressed: onCancel,
        child: Text(context.l10n.commonButtonCancel),
      ),
    );

    if (onClear == null) return cancel;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onClear,
            // The app's OutlinedButton theme is a rounded rectangle while the
            // tonal Cancel keeps M3's pill; forcing the stadium here makes the
            // pair read as one control instead of two mismatched shapes.
            style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
            child: Text(context.l10n.commonButtonClear),
          ),
        ),
        const SizedBox(width: AppDimensions.spaceSm),
        Expanded(child: cancel),
      ],
    );
  }
}
