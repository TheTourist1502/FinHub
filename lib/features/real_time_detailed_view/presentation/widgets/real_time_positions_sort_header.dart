import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_positions_view_state.dart';
import 'package:finhub/shared/widgets/sort/sort_header_row.dart';
import 'package:finhub/shared/widgets/sort/sort_menu_button.dart';
import 'package:flutter/material.dart';

/// "ALL HOLDINGS (n)" header with the sort control for the positions list.
///
/// The sort control is hidden when there is nothing meaningful to reorder.
class RealTimePositionsSortHeader extends StatelessWidget {
  /// Creates a [RealTimePositionsSortHeader].
  const RealTimePositionsSortHeader({
    required this.count,
    required this.view,
    required this.onChanged,
    super.key,
  });

  /// Number of positions currently shown.
  final int count;

  /// Active search + sort selection.
  final RealTimePositionsViewState view;

  /// Called with the newly selected sort field and direction.
  final void Function(String id, {required bool descending}) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SortHeaderRow(
      label: l10n.realTimeAllHoldings(count).toUpperCase(),
      sortMenuButton: count > 1
          ? SortMenuButton(
              fields: [
                SortField(id: RealTimePositionsViewState.fieldValue, label: l10n.commonValue),
                SortField(id: RealTimePositionsViewState.fieldName, label: l10n.commonName),
              ],
              activeFieldId: view.sortField,
              isDescending: view.sortDescending,
              onChanged: onChanged,
            )
          : null,
    );
  }
}
