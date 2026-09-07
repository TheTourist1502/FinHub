import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_data.dart';
import 'package:finhub/features/my_commissions/presentation/widgets/my_commission_metric_card.dart';
import 'package:finhub/features/my_commissions/presentation/widgets/top_accounts_card.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class CommissionsOverviewTab extends StatelessWidget {
  /// Creates a [CommissionsOverviewTab].
  const CommissionsOverviewTab({required this.data, required this.onRefresh, super.key});

  /// Full commission data loaded from the repository.
  final CommissionData data;

  /// Called when the user pulls to refresh.
  final Future<void> Function() onRefresh;

  /// Section heading — "Top 5 Accounts" at 5+, "Top Accounts" for 2-4, or
  /// "Top Account" (singular) for exactly 1.
  String _topAccountsHeading(AppLocalizations l10n, int count) {
    if (count >= 5) return l10n.myCommissionsTopAccounts;
    if (count == 1) return l10n.myCommissionsTopAccountSingular;
    return l10n.myCommissionsTopAccountsPlural;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final topAccounts = data.topAccounts;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── KPI tiles — households + accounts ──────────────────────────
            Row(
              children: [
                // Both tiles sit above the fold, so they settle in on mount.
                Expanded(
                  child: SettleIn(
                    child: MyCommissionMetricCard(
                      icon: Mdi.account_group,
                      count: data.householdsContributing,
                      label: l10n.myCommissionsHouseholds,
                      sublabel: l10n.myCommissionsContributing,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SettleIn(
                    index: 1,
                    child: MyCommissionMetricCard(
                      icon: Mdi.wallet_outline,
                      count: data.accountsContributing,
                      label: l10n.myCommissionsAccountsLabel,
                      sublabel: l10n.myCommissionsContributing,
                    ),
                  ),
                ),
              ],
            ),

            // ── Top accounts heading + list — omitted when there are none ───
            if (topAccounts.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: _topAccountsHeading(l10n, topAccounts.length).toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: colors.textPrimary,
                        height: 20 / 16,
                      ),
                    ),
                    // TextSpan(
                    //   text: ' ${l10n.myCommissionsTopAccountsSubtitle}',
                    //   style: TextStyle(
                    //     fontFamily: 'Inter',
                    //     fontWeight: FontWeight.w500,
                    //     fontSize: 14,
                    //     color: colors.textSecondary,
                    //     height: 16 / 14,
                    //     letterSpacing: 0,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Ranked rows arrive one at a time as the reader scrolls to
              // them, the same entrance the accounts list uses.
              ...topAccounts
                  .take(5)
                  .indexed
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SettleIn(
                        index: entry.$1,
                        revealOnScroll: true,
                        child: TopAccountsCard(account: entry.$2),
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}
