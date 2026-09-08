import 'package:finhub/features/task_dashboard/presentation/widgets/task_detail_cell.dart';
import 'package:flutter/material.dart';

/// Lays task detail cells out two per row, letting a trailing odd cell take
/// the last row on its own.
class TaskDetailGrid extends StatelessWidget {
  /// Creates a [TaskDetailGrid] over [cells], in order.
  const TaskDetailGrid({required this.cells, super.key});

  /// Cells to lay out, read left-to-right then top-to-bottom.
  final List<TaskDetailCell> cells;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < cells.length; i += 2) ...[
          if (i > 0) const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cells[i]),
              if (i + 1 < cells.length) ...[
                const SizedBox(width: 16),
                Expanded(child: cells[i + 1]),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
