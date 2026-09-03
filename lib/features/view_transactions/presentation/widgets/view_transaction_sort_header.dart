import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/view_transactions/presentation/providers/view_transaction_provider.dart';
import 'package:finhub/shared/widgets/sort/sort_header_row.dart';
import 'package:finhub/shared/widgets/sort/sort_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Count label plus sort menu shown above the transaction list.
///
/// Watches the sort providers itself so changing the sort never rebuilds the
/// search field or the chips.
class ViewTransactionSortHeader extends ConsumerWidget {
  /// Creates a [ViewTransactionSortHeader].
  const ViewTransactionSortHeader({required this.showSortMenu, super.key});

  /// Whether the sort menu is offered; hidden when there is nothing to reorder.
  final bool showSortMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sortField = ref.watch(viewTransactionSortFieldProvider);
    final isDescending = ref.watch(viewTransactionSortDescendingProvider);

    return SortHeaderRow(
      label: l10n.viewTransactionsAllHeader.toUpperCase(),
      labelFlex: 45,
      sortFlex: 55,
      sortMenuButton: showSortMenu
          ? SortMenuButton(
              fields: [
                SortField(id: 'date', label: l10n.commonDate),
                SortField(id: 'amount', label: l10n.commonAmount),
                SortField(id: 'account', label: l10n.commonName),
              ],
              activeFieldId: sortField,
              isDescending: isDescending,
              onChanged: (id, {required descending}) {
                ref.read(viewTransactionSortFieldProvider.notifier).field = id;
                ref.read(viewTransactionSortDescendingProvider.notifier).descending = descending;
              },
            )
          : null,
    );
  }
}
