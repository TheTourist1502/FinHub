import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_transactions_card.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_transactions_date_header.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_transactions_view_state.dart';
import 'package:flutter/material.dart';

/// One lazily built list entry: the activity card, preceded by its snapshot
/// header when the row opens a new group.
class RealTimeTransactionsRow extends StatelessWidget {
  /// Creates a [RealTimeTransactionsRow] for [row].
  const RealTimeTransactionsRow({required this.row, super.key});

  /// The activity plus its optional group header.
  final RealTimeTransactionRowData row;

  @override
  Widget build(BuildContext context) {
    final header = row.dateHeader;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) RealTimeTransactionsDateHeader(label: header),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RealTimeTransactionsCard(activity: row.transaction),
        ),
      ],
    );
  }
}
