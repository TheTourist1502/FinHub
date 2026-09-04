import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Vertical gap between the search row, the filter chips and the request list.
///
/// Shared with `ServiceRequestListScreen`'s loaded body rather than repeated
/// on both sides: the skeleton and the real layout have to occupy identical
/// heights, or the screen visibly jumps the moment the data lands.
const double kServiceRequestSectionGap = 12;

/// Height of one filter chip: `TransactionFilterChip`'s 7px vertical padding
/// and 1px border above and below its 12px label line.
const double _kFilterChipHeight = 30;

/// Gap between the stacked text lines inside a request row, matching the
/// card's own `SizedBox(height: 4)` separators.
const double _kRowLineGap = 4;

/// Whole-screen loading skeleton for the Service Requests tab.
///
/// The search row is [AppSearchFieldShimmer], which brings its own shimmer;
/// below it a single [Shimmer.fromColors] drives the chip row and the list
/// together. That is the point of the widget: those two regions previously
/// each wrapped their own shimmer, so each ran a separate `AnimationController`
/// on its own clock and the highlight crossed them at different times instead
/// of reading as one sweep down the page.
class ServiceRequestListShimmer extends StatelessWidget {
  /// Creates a [ServiceRequestListShimmer].
  const ServiceRequestListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        const AppSearchFieldShimmer(),
        const SizedBox(height: kServiceRequestSectionGap),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: colors.bgPrimary,
            highlightColor: colors.surfaceDefault,
            child: const Column(
              children: [
                _FilterChipsSkeleton(),
                SizedBox(height: kServiceRequestSectionGap),
                Expanded(child: _RequestListSkeleton()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Three pill outlines at the real chip height.
///
/// Always three, even though an endpoint failure withdraws the "All" chip:
/// the remaining two keep their positions, so the row never shifts sideways
/// when the real chips drop in.
class _FilterChipsSkeleton extends StatelessWidget {
  const _FilterChipsSkeleton();

  @override
  Widget build(BuildContext context) => const Align(
    alignment: AlignmentDirectional.centerStart,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ShimmerBox(height: _kFilterChipHeight, width: 62, borderRadius: 9999),
        SizedBox(width: 8),
        _ShimmerBox(height: _kFilterChipHeight, width: 76, borderRadius: 9999),
        SizedBox(width: 8),
        _ShimmerBox(height: _kFilterChipHeight, width: 76, borderRadius: 9999),
      ],
    ),
  );
}

/// Count heading, then two labelled sections of standalone cards — mirroring
/// the Active / Closed shape `_ServiceRequestList` renders once loaded.
class _RequestListSkeleton extends StatelessWidget {
  const _RequestListSkeleton();

  @override
  Widget build(BuildContext context) => ListView(
    // Scrollable rather than inert so a pull-to-refresh started while the
    // skeleton is still up reaches the RefreshIndicator wrapping it.
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.only(top: 4, bottom: 16),
    children: const [
      // Heading row: count label placeholder.
      Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: _ShimmerBox(height: 12, width: 150),
      ),

      // Section 1: Active.
      _ShimmerBox(height: 12, width: 90),
      SizedBox(height: 8),
      _StandaloneCardSkeleton(),
      SizedBox(height: 8),
      _StandaloneCardSkeleton(),
      SizedBox(height: 16),

      // Section 2: Closed.
      _ShimmerBox(height: 12, width: 90),
      SizedBox(height: 8),
      _StandaloneCardSkeleton(),
      SizedBox(height: 8),
      _StandaloneCardSkeleton(),
    ],
  );
}

/// Skeleton card mirroring `ServiceRequestStandaloneCard`'s border, radius,
/// shadow and padding.
class _StandaloneCardSkeleton extends StatelessWidget {
  const _StandaloneCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderDefault),
        boxShadow: [BoxShadow(color: colors.cardShadow, blurRadius: 1, offset: const Offset(0, 1))],
      ),
      child: const _RowSkeleton(),
    );
  }
}

/// Shimmer content mirroring a request row's icon circle plus its three text
/// lines: the status-badge / view-link row, the account line, and the due-date
/// line.
class _RowSkeleton extends StatelessWidget {
  const _RowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShimmerCircle(size: 48),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge + "View" link.
              Row(
                children: [
                  _ShimmerBox(height: 15, width: 70),
                  Spacer(),
                  _ShimmerBox(height: 14, width: 40),
                ],
              ),
              SizedBox(height: _kRowLineGap),
              // Account number • financial account type.
              _ShimmerBox(height: 15, width: 140),
              SizedBox(height: _kRowLineGap),
              // Calendar icon + due date.
              _ShimmerBox(height: 16, width: 110),
            ],
          ),
        ),
      ],
    );
  }
}

/// Circular placeholder block, used for the request-type icon.
///
/// Painted solid white because the colour comes from the ancestor
/// [Shimmer.fromColors] gradient — these primitives only supply the shape it
/// is masked to.
class _ShimmerCircle extends StatelessWidget {
  const _ShimmerCircle({required this.size});

  /// Diameter, matched to the real widget this circle stands in for.
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
  );
}

/// Rounded rectangle placeholder block used inside the skeletons.
///
/// Sized in absolute pixels rather than to the text it replaces: there is no
/// text yet, and the widths are chosen to approximate typical content so the
/// skeleton reads as a list rather than as uniform bars.
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 4,
  });

  /// Placeholder height, matched to the line height it stands in for.
  final double height;

  /// Placeholder width; defaults to filling the available space.
  final double width;

  /// Corner rounding — 9999 turns the box into a pill for chip placeholders.
  final double borderRadius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(borderRadius)),
  );
}
