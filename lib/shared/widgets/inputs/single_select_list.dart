import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/shared/widgets/inputs/select_option.dart';
import 'package:finhub/shared/widgets/inputs/single_select_item.dart';
import 'package:flutter/material.dart';

/// Scrollable option list for the single-select sheet.
///
/// Owns the scroll notification hook so pagination fires without rebuilding
/// the surrounding sheet chrome.
class SingleSelectList<T> extends StatelessWidget {
  /// Renders [options] plus an optional trailing loading row.
  const SingleSelectList({
    required this.scrollController,
    required this.options,
    required this.selectedValue,
    required this.showLoadingFooter,
    required this.onSelected,
    required this.onScrollNotification,
    super.key,
  });

  /// Controller supplied by the draggable sheet.
  final ScrollController scrollController;

  /// Options to render, already filtered.
  final List<SelectOption<T>> options;

  /// Currently selected value, highlighted in the list.
  final T? selectedValue;

  /// Whether to append a spinner row while the next page loads.
  final bool showLoadingFooter;

  /// Called with the tapped option's value.
  final ValueChanged<T> onSelected;

  /// Forwarded to a [NotificationListener] to drive load-more.
  final bool Function(ScrollNotification) onScrollNotification;

  @override
  Widget build(BuildContext context) {
    final itemCount = options.length + (showLoadingFooter ? 1 : 0);

    return NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification,
      child: ListView.separated(
        controller: scrollController,
        itemCount: itemCount,
        separatorBuilder: (_, _) => const _ItemSeparator(),
        itemBuilder: (_, i) {
          if (i >= options.length) return const _LoadingFooter();
          final option = options[i];
          return SingleSelectItem(
            label: option.label,
            selected: option.value == selectedValue,
            onTap: () => onSelected(option.value),
          );
        },
      ),
    );
  }
}

/// Inset hairline drawn between option rows.
class _ItemSeparator extends StatelessWidget {
  const _ItemSeparator();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 54,
      endIndent: AppDimensions.spaceMd,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
    );
  }
}

/// Trailing spinner row shown while a further page is being fetched.
class _LoadingFooter extends StatelessWidget {
  const _LoadingFooter();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.spaceMd),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
