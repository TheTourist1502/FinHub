import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:flutter/material.dart';

/// Empty-state card shown when the advisor has no recent transactions.
///
/// Mirrors the populated list container so the dashboard keeps its rhythm.
class RecentTransactionsEmptyCard extends StatelessWidget {
  /// Creates a [RecentTransactionsEmptyCard].
  const RecentTransactionsEmptyCard({super.key});

  /// Fixed height, matching the dashboard's other empty-state cards.
  static const double _cardHeight = 240;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      height: _cardHeight,
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderDefault),
      ),
      // scaleDown keeps the illustration within the fixed height on wide
      // screens, where a screen-width fraction would overflow vertically.
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        child: NoRecordWidget(widthFactor: 0.15),
      ),
    );
  }
}
