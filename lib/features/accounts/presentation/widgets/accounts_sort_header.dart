import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/accounts/domain/models/account_sort_field.dart';
import 'package:finhub/features/accounts/presentation/providers/accounts_provider.dart';
import 'package:finhub/shared/widgets/sort/sort_header_row.dart';
import 'package:finhub/shared/widgets/sort/sort_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Count header above the accounts list, with the sort control on the right.
///
/// Owns the sort-provider watches so sorting state stays out of the screen.
class AccountsSortHeader extends ConsumerWidget {
  /// Creates an [AccountsSortHeader]; [showSortMenu] hides the control when
  /// there is nothing meaningful to sort (a single result or fewer), and
  /// [count] is the number shown in the header label.
  const AccountsSortHeader({required this.count, required this.showSortMenu, super.key});

  /// Number of accounts shown in the label (e.g. "ALL ACCOUNTS (24)").
  final int count;

  /// Whether the sort menu button is rendered.
  final bool showSortMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SortHeaderRow(
      label: context.l10n.accountsAllLabel(count).toUpperCase(),
      sortMenuButton: showSortMenu
          ? SortMenuButton(
              fields: [
                SortField(id: AccountSortField.aum.id, label: context.l10n.dashboardAumLabel),
                SortField(id: AccountSortField.name.id, label: context.l10n.commonName),
              ],
              activeFieldId: ref.watch(accountsSortFieldProvider).id,
              isDescending: ref.watch(accountsSortProvider),
              onChanged: (id, {required descending}) {
                ref.read(accountsSortFieldProvider.notifier).field = AccountSortField.fromId(id);
                ref.read(accountsSortProvider.notifier).descending = descending;
              },
            )
          : null,
    );
  }
}
