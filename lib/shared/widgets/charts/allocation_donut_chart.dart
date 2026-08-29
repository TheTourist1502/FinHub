import 'dart:ui' show lerpDouble;

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/asset_class_labels.dart';
import 'package:finhub/core/utils/currency_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 128×128 donut chart with an animated centre label, shared by every
/// asset-allocation card (dashboard, household detail, account detail).
///
/// Three animations:
///  * The ring draws round like a clock hand from twelve o'clock, one slice
///    completing before the next begins, rather than every slice growing
///    together. An allocation *is* a set of parts accumulating to a whole, so
///    drawing it in order shows the reader the composition being built; all
///    slices swelling at once only shows them that something is loading. The
///    sweep is computed frame by frame in [_sweptPercentages] and driven by a
///    keyed [TweenAnimationBuilder] (see [_AllocationDonutChartState]) rather
///    than by `PieChart`'s own implicit tween, which would diff before and
///    after states instead. Replays whenever [dataIdentity] actually changes
///    (a genuine API refetch — first load or pull-to-refresh), not on every
///    rebuild: a slice tap changes only [highlightedIndex], which leaves
///    [dataIdentity] untouched.
///  * The highlighted slice grows out to [highlightedRadius] as the ring
///    completes, so the chart picks out its primary asset class at the end of
///    the draw instead of starting already pointing at it.
///  * Both centre figures — the percentage and the market value — count up
///    alongside the sweep, so the ring and the numbers labelling it resolve
///    together rather than the ring arriving at a figure already settled.
///  * The centre label crossfades whenever the resolved centre index
///    changes (e.g. a slice tap), instead of jump-cutting to the new asset
///    class.
class AllocationDonutChart extends StatefulWidget {
  /// Creates an [AllocationDonutChart]. All lists must be the same length
  /// and index-aligned to one asset class each; [highlightedIndex] must be
  /// a valid index into them.
  const AllocationDonutChart({
    required this.assetClasses,
    required this.marketValues,
    required this.percentages,
    required this.sliceColors,
    required this.highlightedIndex,
    required this.highlightedRadius,
    required this.onSliceTap,
    required this.dataIdentity,
    super.key,
  });

  /// Asset class name per slice (e.g. `'Equity'`) — also the centre label's
  /// crossfade identity key.
  final List<String> assetClasses;

  /// Market value per slice, index-aligned to [assetClasses].
  final List<double> marketValues;

  /// Allocation percentage per slice, index-aligned to [assetClasses].
  final List<double> percentages;

  /// Rendered colour per slice, index-aligned to [assetClasses].
  final List<Color> sliceColors;

  /// Index of the slice shown in the centre label and sliced out with
  /// [highlightedRadius] — the tapped slice, or the caller's own default
  /// (typically the highest-allocation class).
  final int highlightedIndex;

  /// Outer radius the highlighted slice grows out to, in logical pixels.
  /// Unhighlighted slices stay at [_baseRadius] — callers differ only on the
  /// highlighted size (dashboard uses 26; detail-screen cards use 24).
  final double highlightedRadius;

  /// Called with a tapped slice's index.
  final ValueChanged<int> onSliceTap;

  /// Identity token for the current batch of allocation data — pass the
  /// caller's own source list (e.g. `DetailedAccount.assetAllocation`),
  /// never read for its content here, only compared by reference in
  /// [_AllocationDonutChartState.didUpdateWidget] to detect a genuine
  /// refetch (Riverpod/async providers return the same List instance across
  /// unrelated rebuilds until they actually refetch) versus an unrelated
  /// rebuild such as a slice tap.
  final Object dataIdentity;

  @override
  State<AllocationDonutChart> createState() => _AllocationDonutChartState();
}

/// Outer radius of an unhighlighted slice, in logical pixels, and the radius
/// every slice starts the reveal at.
const double _baseRadius = 21;

class _AllocationDonutChartState extends State<AllocationDonutChart> {
  /// Identity of the data batch currently driving the reveal sweep.
  ///
  /// Changes only when [AllocationDonutChart.dataIdentity] actually changes
  /// (a genuine refetch — first load or pull-to-refresh) — see
  /// [didUpdateWidget]. Used as the [TweenAnimationBuilder]'s own [Key]
  /// below: giving it a new key forces Flutter to discard the old one and
  /// mount a fresh instance, which — per [TweenAnimationBuilder]'s own
  /// documented behaviour — always animates from its tween's `begin` value
  /// on mount, replaying the sweep. An unrelated rebuild (e.g. a slice tap,
  /// which only changes [AllocationDonutChart.highlightedIndex]) leaves
  /// this key untouched, so [TweenAnimationBuilder] just updates in place
  /// at its already-completed value instead of restarting.
  late Object _revealKey;

  /// `true` once the current reveal sweep has finished, so `PieChart` goes
  /// back to tweening its own [PieChartSectionData.radius] changes (e.g. a
  /// tapped slice growing) instead of racing its own implicit duration
  /// against the explicitly-driven reveal value on every frame — see
  /// [build].
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _revealKey = widget.dataIdentity;
  }

  @override
  void didUpdateWidget(covariant AllocationDonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.dataIdentity, widget.dataIdentity)) {
      setState(() {
        _revealKey = widget.dataIdentity;
        _revealed = false;
      });
    }
  }

  /// The percentage each slice has drawn at [progress], as a clock-hand sweep
  /// around the ring.
  ///
  /// [progress] is read as a fraction of the ring's whole span, so a slice
  /// stays at zero until the hand reaches it, fills as the hand crosses it,
  /// and holds at its full value once passed. Summing the real percentages
  /// rather than assuming they reach 100 keeps the hand's pace honest when the
  /// backend sends a set that does not quite total up.
  List<double> _sweptPercentages(double progress) {
    // A slice can arrive negative or non-finite — a short position, a negative
    // cash balance, or a malformed figure — and a wedge cannot be drawn
    // backwards. Each is floored to zero for the sweep: it contributes no arc,
    // the legend beside the ring still reports its real value, and `clamp`
    // keeps a valid range instead of throwing on `lowerLimit > upperLimit`.
    final drawable = [for (final p in widget.percentages) p.isFinite && p > 0 ? p : 0.0];
    final total = drawable.fold<double>(0, (sum, p) => sum + p);
    var remaining = total * progress;
    final swept = <double>[];
    for (final percentage in drawable) {
      final drawn = remaining.clamp(0.0, percentage);
      swept.add(drawn);
      remaining -= percentage;
    }
    return swept;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return TweenAnimationBuilder<double>(
      key: ValueKey(_revealKey),
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.duration(context, AppMotion.settle),
      curve: AppMotion.enter,
      onEnd: () {
        if (mounted) setState(() => _revealed = true);
      },
      builder: (context, progress, _) {
        final swept = _sweptPercentages(progress);
        final sections = List.generate(widget.assetClasses.length, (i) {
          return PieChartSectionData(
            value: swept[i],
            color: widget.sliceColors[i],
            // The highlight grows in with the sweep. Once revealed, `progress`
            // is 1 and this is a plain `highlightedRadius`, leaving `PieChart`
            // to tween the radius itself when a different slice is tapped.
            radius: i == widget.highlightedIndex
                ? lerpDouble(_baseRadius, widget.highlightedRadius, progress)!
                : _baseRadius,
            cornerRadius: 4,
            title: '',
            showTitle: false,
          );
        });

        return SizedBox(
          width: 128,
          height: 136,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                // Zero while the reveal sweep is in progress, so `PieChart`
                // paints exactly the value this builder computes each frame
                // instead of also chasing it with its own lag on top —
                // restored once revealed, so a later slice tap still
                // animates its radius change smoothly.
                duration: _revealed ? AppMotion.duration(context, AppMotion.quick) : Duration.zero,
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 42,
                  sectionsSpace: 1,
                  startDegreeOffset: -90,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      if (event is! FlTapUpEvent) return;
                      final index = response?.touchedSection?.touchedSectionIndex;
                      if (index == null || index < 0) return;
                      widget.onSliceTap(index);
                    },
                  ),
                ),
              ),
              // Centre label — tapped slice, or whatever the caller resolved
              // as the default. Crossfades between asset classes (keyed on
              // the class name) instead of jump-cutting when a different
              // slice is tapped, in step with the donut's own radius tween.
              SizedBox(
                width: 76,
                height: 76,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AnimatedSwitcher(
                    duration: AppMotion.duration(context, AppMotion.quick),
                    child: Column(
                      key: ValueKey(widget.assetClasses[widget.highlightedIndex]),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          assetClassMediumLabel(context.l10n, widget.assetClasses[widget.highlightedIndex]),
                          style: AppTypography.donutCenterLabel.copyWith(color: colors.textSecondary),
                        ),
                        Text(
                          '${(widget.percentages[widget.highlightedIndex] * progress).toStringAsFixed(1)}%',
                          style: AppTypography.donutCenterPercentage.copyWith(color: colors.textBrandNavyBlue),
                        ),
                        Text(
                          compactDollar(widget.marketValues[widget.highlightedIndex] * progress),
                          style: AppTypography.donutCenterValue.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
