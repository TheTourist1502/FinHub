import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:flutter/material.dart';

/// Empty state for the transactions tab, stretched to the full viewport inside
/// an always-scrollable list so pull-to-refresh still works with no rows.
class RealTimeTransactionsEmptyState extends StatelessWidget {
  /// Creates a [RealTimeTransactionsEmptyState].
  const RealTimeTransactionsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: constraints.maxHeight,
            child: NoRecordWidget(widthFactor: 0.45, message: context.l10n.realTimeNoTransactions),
          ),
        ],
      ),
    );
  }
}
