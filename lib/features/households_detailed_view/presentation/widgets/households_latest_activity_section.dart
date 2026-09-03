import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/date_sort_utils.dart';
import 'package:finhub/features/households_detailed_view/domain/models/household_detail_view.dart';
import 'package:finhub/features/households_detailed_view/presentation/widgets/households_latest_activity_card.dart';
import 'package:flutter/material.dart';

/// "Latest Activity" section of the household overview.
///
/// Picks the newest transaction and renders it; collapses to nothing when the
/// household has no transactions.
class HouseholdsLatestActivitySection extends StatelessWidget {
  /// Creates a [HouseholdsLatestActivitySection].
  const HouseholdsLatestActivitySection({required this.transactions, super.key});

  /// Household transactions in any order.
  final List<HouseholdDetailTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) return const SizedBox.shrink();

    /// Latest by transaction date; the source list order is not guaranteed.
    ///
    /// [compareDatesDesc] keeps undated transactions last, so one is only
    /// shown here when every transaction is undated.
    final latest = transactions.reduce(
      (a, b) => compareDatesDesc(a.transactionDate, b.transactionDate) <= 0 ? a : b,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(context.l10n.accountDetailLatestActivity, style: AppTypography.cardTitle),
        const SizedBox(height: 12),
        HouseholdsLatestActivityCard(transaction: latest),
      ],
    );
  }
}
