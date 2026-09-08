import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Full-list shimmer placeholder shown while [filteredTasksProvider] loads,
/// in place of `_TaskList` in `TaskDashboardScreen`.
///
/// Mirrors the visual structure of the real list: a heading row, two
/// standalone-card sections (e.g. overdue, open), and one grouped-card
/// section (e.g. upcoming) — matching [TaskStandaloneCard] and
/// [TaskGroupedRow].
class TaskDashboardListShimmer extends StatelessWidget {
  /// Creates a [TaskDashboardListShimmer].
  const TaskDashboardListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Shimmer.fromColors(
      baseColor: colors.bgPrimary,
      highlightColor: colors.surfaceDefault,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 32),
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          // Heading row
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerBox(width: 130, height: 12),
                _ShimmerBox(width: 80, height: 12),
              ],
            ),
          ),

          // Section 1 — 2 standalone cards (e.g. overdue)
          _ShimmerSectionLabel(),
          SizedBox(height: 8),
          _ShimmerStandaloneCard(),
          SizedBox(height: 8),
          _ShimmerStandaloneCard(),
          SizedBox(height: 16),

          // Section 2 — grouped card with 3 rows (e.g. upcoming)
          _ShimmerSectionLabel(),
          SizedBox(height: 8),
          _ShimmerGroupedCard(rows: 3),
          SizedBox(height: 16),

          // Section 3 — 1 standalone card (e.g. open)
          _ShimmerSectionLabel(),
          SizedBox(height: 8),
          _ShimmerStandaloneCard(),
        ],
      ),
    );
  }
}

/// Placeholder for a `TaskSectionLabel`.
class _ShimmerSectionLabel extends StatelessWidget {
  const _ShimmerSectionLabel();

  @override
  Widget build(BuildContext context) => const _ShimmerBox(width: 64, height: 11);
}

/// Skeleton that mirrors [TaskStandaloneCard]: icon circle, status badge,
/// client line, title, and due row.
class _ShimmerStandaloneCard extends StatelessWidget {
  const _ShimmerStandaloneCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderDefault),
        boxShadow: [BoxShadow(color: colors.cardShadow, blurRadius: 1, offset: const Offset(0, 1))],
      ),
      padding: const EdgeInsets.all(17),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerCircle(size: 48),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _ShimmerBox(width: 88, height: 18),
                    Spacer(),
                    _ShimmerBox(width: 28, height: 12),
                  ],
                ),
                SizedBox(height: 5),
                _ShimmerBox(width: 110, height: 10),
                SizedBox(height: 5),
                _ShimmerBox(height: 14),
                SizedBox(height: 6),
                _ShimmerBox(width: 90, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton that mirrors a run of [TaskGroupedRow]s: multiple rows separated by dividers.
class _ShimmerGroupedCard extends StatelessWidget {
  const _ShimmerGroupedCard({required this.rows});
  final int rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderDefault),
        boxShadow: [BoxShadow(color: colors.cardShadow, blurRadius: 2, offset: const Offset(0, 1))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < rows; i++)
            Container(
              decoration: i < rows - 1
                  ? BoxDecoration(
                      border: Border(bottom: BorderSide(color: colors.borderSubtle)),
                    )
                  : null,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerCircle(size: 48),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: _ShimmerBox(height: 14)),
                            SizedBox(width: 8),
                            _ShimmerBox(width: 28, height: 12),
                          ],
                        ),
                        SizedBox(height: 5),
                        _ShimmerBox(width: 80, height: 10),
                        SizedBox(height: 6),
                        _ShimmerBox(width: 90, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Circular shimmer placeholder (icon circle).
class _ShimmerCircle extends StatelessWidget {
  const _ShimmerCircle({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    );
  }
}

/// Rectangular shimmer placeholder with 4 px rounded corners.
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.height, this.width = double.infinity});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
    );
  }
}
