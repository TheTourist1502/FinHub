import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/shared/widgets/inputs/multi_select_item.dart';
import 'package:finhub/shared/widgets/inputs/select_option.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Scrollable checkbox list for the multi-select sheet.
///
/// Stateless and independent of the selection set — each row subscribes to
/// [selection] on its own, so the list is not rebuilt on a toggle.
class MultiSelectList<T> extends StatelessWidget {
  /// Renders [options] as checkbox rows driven by [selection].
  const MultiSelectList({
    required this.scrollController,
    required this.options,
    required this.selection,
    required this.onToggle,
    super.key,
  });

  /// Controller supplied by the draggable sheet.
  final ScrollController scrollController;

  /// Options to render, already filtered.
  final List<SelectOption<T>> options;

  /// Live set of chosen values shared with every row.
  final ValueListenable<Set<T>> selection;

  /// Called with the tapped option's value.
  final ValueChanged<T> onToggle;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      itemCount: options.length,
      separatorBuilder: (_, _) => const _ItemSeparator(),
      itemBuilder: (_, i) {
        final option = options[i];
        return MultiSelectItem<T>(
          label: option.label,
          value: option.value,
          selection: selection,
          onToggle: onToggle,
        );
      },
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
      indent: 56,
      endIndent: AppDimensions.spaceMd,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
    );
  }
}
