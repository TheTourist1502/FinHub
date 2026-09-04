import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/shared/widgets/sort/sort_header_row.dart';
import 'package:finhub/shared/widgets/sort/sort_menu_button.dart';
import 'package:flutter/material.dart';

/// "ALL TRANSACTIONS (n)" header with the sort-by-value control,
/// which is hidden when there is nothing to reorder.
class RealTimeTransactionsSortHeader extends StatelessWidget {
  /// Creates a [RealTimeTransactionsSortHeader].
  const RealTimeTransactionsSortHeader({
    required this.count,
    required this.isDescending,
    required this.onSortChanged,
    super.key,
  });

  /// Sort field id; the tab offers value as the only sortable field.
  static const fieldValue = 'value';

  /// Number of activities currently shown.
  final int count;

  /// Whether the list is sorted from highest to lowest value.
  final bool isDescending;

  /// Called with the new direction when the user picks a sort order.
  final void Function({required bool descending}) onSortChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SortHeaderRow(
      label: l10n.realTimeAllTransactionsHeader(count).toUpperCase(),
      sortMenuButton: count > 1
          ? SortMenuButton(
              fields: [SortField(id: fieldValue, label: l10n.commonValue)],
              activeFieldId: fieldValue,
              isDescending: isDescending,
              onChanged: (id, {required descending}) => onSortChanged(descending: descending),
            )
          : null,
    );
  }
}
