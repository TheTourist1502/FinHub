import 'package:finhub/features/accounts/domain/models/account.dart';
import 'package:finhub/features/households_detailed_view/domain/models/household_detail_view.dart';
import 'package:finhub/features/households_detailed_view/presentation/widgets/households_asset_allocation.dart';
import 'package:finhub/features/households_detailed_view/presentation/widgets/households_latest_activity_section.dart';
import 'package:finhub/features/households_detailed_view/presentation/widgets/households_top_accounts_card.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:flutter/material.dart';

/// Overview tab for the household detail screen.
///
/// Stacks the asset-allocation chart, the top-5 accounts by AUM, and the
/// latest activity card. Matches Figma node 2254-4680.
class HouseholdsOverviewTab extends StatelessWidget {
  /// Creates a [HouseholdsOverviewTab].
  const HouseholdsOverviewTab({required this.household, required this.onRefresh, this.onAccountTap, super.key});

  /// The loaded household data to display.
  final HouseholdDetailView household;

  /// Called when the user pulls to refresh.
  final Future<void> Function() onRefresh;

  /// Overrides "View Details" navigation for each top-account row; when `null`
  /// the row pushes the real account detail route.
  final void Function(Account account)? onAccountTap;

  @override
  Widget build(BuildContext context) {
    final topAccounts = household.topAccounts;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          // Sections settle in as a group, the same entrance the dashboard
          // gives its own stack of cards. The allocation card is the only one
          // above the fold, so the two below it wait to be scrolled to rather
          // than finishing their entrance unseen.
          SettleIn(child: HouseholdsAssetAllocation(household: household)),
          const SizedBox(height: 16),
          if (topAccounts.isNotEmpty)
            SettleIn(
              index: 1,
              revealOnScroll: true,
              child: HouseholdsTopAccountsCard(
                accounts: topAccounts,
                total: household.accounts.length,
                onAccountTap: onAccountTap,
              ),
            ),
          SettleIn(
            index: 2,
            revealOnScroll: true,
            child: HouseholdsLatestActivitySection(transactions: household.transactions),
          ),
        ],
      ),
    );
  }
}
