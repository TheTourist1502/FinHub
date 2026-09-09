import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Full-list shimmer placeholder shown while the notification list's initial
/// fetch is in flight.
///
/// Mirrors the real list's single grouped card (see `_NotificationsBody`'s
/// data branch): one rounded card holding several [_NotificationRowSkeleton]
/// rows, each matching the icon-badge + title/body/timestamp layout of
/// [NotificationItemCard], separated by hairline dividers.
class NotificationsListShimmer extends StatelessWidget {
  /// Creates a [NotificationsListShimmer].
  const NotificationsListShimmer({super.key});

  static const _rowCount = 10;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.borderDefault),
            boxShadow: [
              BoxShadow(color: colors.cardShadow, blurRadius: 1, offset: const Offset(0, 1)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                for (var i = 0; i < _rowCount; i++) _NotificationRowSkeleton(isLast: i == _rowCount - 1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Skeleton row that mirrors the layout of `NotificationItemCard`: a circular
/// icon-badge placeholder, title/body/timestamp bars, and a hairline divider
/// unless [isLast].
class _NotificationRowSkeleton extends StatelessWidget {
  const _NotificationRowSkeleton({required this.isLast});

  /// Suppresses the bottom divider on the last row.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Shimmer.fromColors(
            baseColor: colors.textDisabled,
            highlightColor: colors.surfaceDefault,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerCircle(size: 48),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ShimmerBox(height: 14, width: 140),
                      SizedBox(height: 6),
                      _ShimmerBox(height: 14),
                      SizedBox(height: 3),
                      _ShimmerBox(height: 14, width: 200),
                      SizedBox(height: 6),
                      _ShimmerBox(height: 11, width: 110),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: colors.borderDefault,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}

/// Circular shimmer placeholder (icon-badge circle).
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

/// Rounded rectangle shimmer placeholder.
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.height, this.width = double.infinity});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
    );
  }
}
