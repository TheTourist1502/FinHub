import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_position.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_positions_card.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:flutter/material.dart';

/// Lazily built list of position cards, so a data refresh only rebuilds the
/// cards currently on screen.
class RealTimePositionsList extends StatelessWidget {
  /// Creates a [RealTimePositionsList] for [positions].
  const RealTimePositionsList({required this.positions, super.key});

  /// Positions to render, already filtered and sorted.
  final List<RealTimePosition> positions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: positions.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        // Cards deal in one at a time as the reader scrolls to them, the same
        // entrance the accounts and holdings lists use. `revealOnScroll` is
        // what makes it worth having: a holdings list is long, so most cards
        // are built below the fold.
        child: SettleIn(
          index: index,
          revealOnScroll: true,
          child: RealTimePositionsCard(position: positions[index]),
        ),
      ),
    );
  }
}
