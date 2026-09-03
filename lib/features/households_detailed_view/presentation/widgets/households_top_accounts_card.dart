import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/features/accounts/domain/models/account.dart';
import 'package:finhub/features/households_detailed_view/presentation/widgets/households_top_account_row.dart';
import 'package:flutter/material.dart';

/// Card listing the household's top accounts by AUM with a "See all" link.
///
/// Rows are divided by hairlines; the header link switches to the Accounts tab.
class HouseholdsTopAccountsCard extends StatelessWidget {
  /// Creates a [HouseholdsTopAccountsCard].
  const HouseholdsTopAccountsCard({
    required this.accounts,
    required this.total,
    this.onAccountTap,
    super.key,
  });

  /// Top accounts sorted by AUM (max 5).
  final List<Account> accounts;

  /// Total account count shown in the "See all (N)" label.
  final int total;

  /// Forwarded to each [HouseholdsTopAccountRow].
  final void Function(Account account)? onAccountTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopAccountsHeader(total: total),
          for (var i = 0; i < accounts.length; i++) ...[
            if (i > 0) const _RowDivider(),
            HouseholdsTopAccountRow(account: accounts[i], onTap: onAccountTap),
          ],
        ],
      ),
    );
  }
}

/// Card header: section title plus the "See all (N)" tab-switch link.
class _TopAccountsHeader extends StatelessWidget {
  const _TopAccountsHeader({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.householdDetailTopAccounts,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () => DefaultTabController.of(context).animateTo(1),
            child: Text(
              l10n.householdDetailSeeAll(total),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.interactiveDefault,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hairline separator drawn between consecutive account rows.
class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.outlineVariant);
  }
}
