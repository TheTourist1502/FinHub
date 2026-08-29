import 'dart:ui' show lerpDouble;

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/asset_class_labels.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:finhub/shared/animations/wipe.dart';
import 'package:flutter/material.dart';

/// A single entry in an asset-class allocation breakdown.
@immutable
class AssetAllocationEntry {
  /// Creates an [AssetAllocationEntry] with the given [assetClass] and [percent].
  const AssetAllocationEntry({required this.assetClass, required this.percent});

  /// Asset class name used for colour lookup and label abbreviation.
  ///
  /// Standard values: `'Equity'`, `'Fixed Income'`, `'Alts'`, `'Cash'`.
  final String assetClass;

  /// Allocation percentage (0–100).
  final double percent;
}

/// Allocation label block + segmented progress bar.
///
/// Shared between [HouseholdCard] and [AccountCard]. Renders:
/// 1. A left-aligned column with the "Asset Allocation" label above the compact
///    summary (e.g. `65.0% Eq / 30.0% FI / 5.0% Cash`).
/// 2. A segmented colour bar where each segment width is proportional to [AssetAllocationEntry.percent].
///
/// Zero-percent entries are silently omitted from both the label and the bar.
/// When more than 5 asset classes remain, only the top 4 by percentage are shown
/// individually and the remainder are combined into a single `'Rest'` entry, so
/// the label and bar never render more than 5 segments.
/// Asset-class colours are the single source of truth via [colorFor] —
/// import this widget wherever a consistent colour reference is needed.
/// Fraction of a percentage the summary label's roll starts from.
const double _entranceFraction = 0.9;

class AssetAllocationSection extends StatelessWidget {
  /// Creates an [AssetAllocationSection] from an ordered [allocations] list.
  const AssetAllocationSection({required this.allocations, super.key});

  /// Ordered list of asset-class entries to display.
  final List<AssetAllocationEntry> allocations;

  /// Maximum number of individual asset-class segments before the remainder are
  /// collapsed into a single `'Rest'` entry.
  static const int _maxIndividualSegments = 4;

  /// Returns [allocations] with zero-percent entries removed — unless every
  /// entry is zero, in which case they are all kept so the label still names
  /// the asset class. All but the top `_maxIndividualSegments - 1` by
  /// percentage are collapsed into a single `'Rest'` entry when there are more
  /// than [_maxIndividualSegments], so the label and bar never render more than
  /// [_maxIndividualSegments] segments.
  List<AssetAllocationEntry> _displayAllocations() {
    final active = allocations.where((e) => e.percent > 0).toList();
    // All-zero allocations still name their asset class (e.g. "0.0% Cash")
    // rather than collapsing to nothing.
    final visible = active.isEmpty ? allocations : active;
    if (visible.length <= _maxIndividualSegments) return visible;

    const topCount = _maxIndividualSegments - 1;
    final sorted = [...visible]..sort((a, b) => b.percent.compareTo(a.percent));
    final top = sorted.take(topCount).toList();
    final restPercent = sorted.skip(topCount).fold<double>(0, (sum, e) => sum + e.percent);
    return [...top, AssetAllocationEntry(assetClass: 'Rest', percent: restPercent)];
  }

  /// Returns the chart colour for the entry at [index] from the active theme.
  ///
  /// Cycles through chart1–chart10 using modulo so any number of asset classes
  /// are consistently coloured. Use this wherever asset-class colours are needed
  /// (pie charts, legends, etc.) to ensure visual consistency across themes.
  static Color colorFor(BuildContext context, int index) {
    final c = context.appColors;
    final colors = [
      c.chart1,
      c.chart2,
      c.chart3,
      c.chart4,
      c.chart5,
      c.chart6,
      c.chart7,
      c.chart8,
      c.chart9,
      c.chart10,
    ];
    return colors[index % colors.length];
  }

  /// Builds the compact summary label at reveal progress [t] (e.g.
  /// `65.0% Eq / 30.0% FI / 5.0% Cash`), rendering each percentage to one
  /// decimal place.
  ///
  /// Percentages count up from [_entranceFraction] of their real figure rather
  /// than from zero, so the label's width — and with it the wrap of the line
  /// below the heading — does not change while it rolls.
  String _summaryLabel(AppLocalizations l10n, List<AssetAllocationEntry> display, double t) {
    final parts = display.map((e) {
      final percent = lerpDouble(e.percent * _entranceFraction, e.percent, t)!;
      return '${percent.toStringAsFixed(1)}% ${assetClassShortLabel(l10n, e.assetClass)}';
    }).toList();
    return parts.isEmpty ? 'N/A' : parts.join(' / ');
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: context.appColors.textSecondary,
    );
    final display = _displayAllocations();
    // Nothing to plot — render nothing rather than a label with an empty bar.
    if (display.isEmpty) return const SizedBox.shrink();

    // Built once here rather than inside the reveal's builder. The same widget
    // instance is handed back every frame, so the segments are reconciled
    // rather than rebuilt 60 times a second — only the clip moves.
    final bar = _AssetAllocationBar(allocations: display);

    // One reveal drives the label's percentages and the bar's wipe together.
    // Two controllers would cost twice the tickers in every list row and drift
    // apart, leaving the label reading a figure the bar has not reached.
    return FigureReveal(
      revealOnScroll: true,
      duration: AppMotion.settle,
      curve: AppMotion.enter,
      builder: (context, t) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.assetAllocationLabel,
                style: labelStyle.copyWith(color: context.appColors.textPrimary, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(_summaryLabel(context.l10n, display, t), style: labelStyle),
            ],
          ),
          const SizedBox(height: 8),
          Wipe(progress: t, child: bar),
        ],
      ),
    );
  }
}

/// Segmented horizontal bar — one coloured segment per active asset class.
class _AssetAllocationBar extends StatelessWidget {
  const _AssetAllocationBar({required this.allocations});

  final List<AssetAllocationEntry> allocations;

  @override
  Widget build(BuildContext context) {
    final active = allocations.where((e) => e.percent > 0).toList();

    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: context.appColors.borderDefault,
        borderRadius: BorderRadius.circular(3),
      ),
      clipBehavior: Clip.hardEdge,
      child: active.isEmpty
          ? null
          // The track stays put while the [Wipe] above lays the coloured
          // segments over it left to right.
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: active.indexed
                  .map(
                    ((int, AssetAllocationEntry) ie) => Expanded(
                      flex: (ie.$2.percent * 100).toInt(),
                      child: ColoredBox(color: AssetAllocationSection.colorFor(context, ie.$1)),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
