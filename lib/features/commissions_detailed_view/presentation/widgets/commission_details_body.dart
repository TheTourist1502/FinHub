import 'package:finhub/features/commissions_detailed_view/presentation/widgets/commission_details_top_card.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/widgets/commission_transactions_list_section.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/widgets/commission_transactions_search_field.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_summary.dart';
import 'package:flutter/material.dart';

/// Scaffold body of the Commission Detailed View.
///
/// The header card and search field render immediately — the card is built
/// from the [summary] carried over on the route, and the field only writes to
/// the search provider — so, following the accounts and households screens,
/// only [CommissionTransactionsListSection] depends on the fetch and swaps
/// between shimmer, error and loaded content. This widget itself watches
/// nothing, so it is built once per route.
class CommissionDetailsBody extends StatelessWidget {
  /// Creates a [CommissionDetailsBody] for [summary].
  const CommissionDetailsBody({required this.summary, super.key});

  /// Summary carried over from the My Commissions list; also the source of the
  /// account id used to fetch the detail rows.
  final CommissionSummary summary;

  @override
  Widget build(BuildContext context) {
    final accountId = summary.accountId!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: CommissionDetailsTopCard(summary: summary),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: CommissionTransactionsSearchField(),
        ),
        const SizedBox(height: 12),
        Expanded(child: CommissionTransactionsListSection(accountId: accountId)),
      ],
    );
  }
}
