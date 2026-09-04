import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_transactions_row.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_transactions_view_state.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:flutter/material.dart';

/// Lazily built list of activity rows, so a data refresh only rebuilds the
/// rows currently on screen.
class RealTimeTransactionsList extends StatelessWidget {
  /// Creates a [RealTimeTransactionsList] for [rows].
  const RealTimeTransactionsList({required this.rows, super.key});

  /// Rows to render, already filtered, sorted, and grouped.
  final List<RealTimeTransactionRowData> rows;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: rows.length,
      // A row carries its own group header, so the header arrives with the
      // card beneath it rather than as a separate entrance.
      itemBuilder: (context, index) => SettleIn(
        index: index,
        revealOnScroll: true,
        child: RealTimeTransactionsRow(row: rows[index]),
      ),
    );
  }
}
