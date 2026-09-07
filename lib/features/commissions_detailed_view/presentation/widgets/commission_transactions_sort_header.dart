import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/providers/commissions_detailed_view_filter_provider.dart';
import 'package:finhub/shared/widgets/sort/sort_header_row.dart';
import 'package:finhub/shared/widgets/sort/sort_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// "All commissions" header with the sort control on the right.
///
/// Watches the sort state itself so changing it never rebuilds the header card
/// or the search field.
class CommissionTransactionsSortHeader extends ConsumerWidget {
  /// Creates a [CommissionTransactionsSortHeader] for [accountId].
  const CommissionTransactionsSortHeader({required this.accountId, super.key});

  /// Account whose filtered transactions decide whether sorting is offered.
  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Sorting is pointless with a single result, so the button is hidden then.
    final canSort = ref.watch(commissionDetailFilteredProvider(accountId).select((txns) => txns.length > 1));

    return SortHeaderRow(
      label: l10n.commissionDetailedViewAllCommissions.toUpperCase(),
      sortMenuButton: canSort
          ? SortMenuButton(
              fields: [
                SortField(
                  id: CommissionDetailSortField.commission,
                  label: l10n.commissionDetailedViewSortCommission,
                ),
                SortField(
                  id: CommissionDetailSortField.transactionAmount,
                  label: l10n.commissionDetailedViewSortTransactionAmount,
                ),
                SortField(id: CommissionDetailSortField.date, label: l10n.commonDate),
                SortField(id: CommissionDetailSortField.name, label: l10n.commonName),
              ],
              activeFieldId: ref.watch(commissionDetailSortFieldProvider),
              isDescending: ref.watch(commissionDetailSortDescendingProvider),
              onChanged: (id, {required descending}) {
                ref.read(commissionDetailSortFieldProvider.notifier).field = id;
                ref.read(commissionDetailSortDescendingProvider.notifier).descending = descending;
              },
            )
          : null,
    );
  }
}
