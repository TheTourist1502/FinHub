import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:finhub/features/dashboard/presentation/widgets/households_insights_card.dart';
import 'package:finhub/features/dashboard/presentation/widgets/households_insights_empty_card.dart';
import 'package:flutter/material.dart';

/// Horizontally scrollable strip of household cards.
///
/// [IntrinsicHeight] gives every card the height of the tallest one; falls back
/// to the empty-state card when there is nothing to show. A lone household is
/// rendered full-width without a scroll view, since there is nothing to scroll.
class HouseholdsInsightsList extends StatelessWidget {
  /// Creates a [HouseholdsInsightsList].
  const HouseholdsInsightsList({required this.households, super.key});

  /// Households to render, in display order.
  final List<HouseholdInsight> households;

  @override
  Widget build(BuildContext context) {
    if (households.isEmpty) return const HouseholdsInsightsEmptyCard();
    if (households.length == 1) {
      return HouseholdsInsightsCard(household: households.first, fullWidth: true);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < households.length; i++) ...[
              if (i > 0) const SizedBox(width: 16),
              HouseholdsInsightsCard(household: households[i]),
            ],
          ],
        ),
      ),
    );
  }
}
