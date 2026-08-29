import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:finhub/shared/widgets/charts/history_chart_widget.dart';
import 'package:finhub/shared/widgets/charts/touch_reactive_aum_hero.dart';
import 'package:finhub/shared/widgets/feedback/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

/// Dashboard section showing the FA's total AUM, period-over-period change,
/// area line chart, and time-range filter chips.
///
/// Owns its own white surface card (bottom-only rounded corners, 20 px radius)
/// with 16/20/16 px padding — no container wrapping needed in the parent screen.
///
/// The hero value comes from [dashboardSummaryProvider] (authoritative server
/// total) while the chart history comes from [faAumHistoryProvider]. Both
/// providers must resolve before content is shown; either loading state
/// renders [_TotalAumTrendShimmer] and either error state renders [ErrorView].
class TotalAumTrendSection extends ConsumerWidget {
  /// Creates a [TotalAumTrendSection].
  const TotalAumTrendSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final historyAsync = ref.watch(faAumHistoryProvider);

    final isLoading = summaryAsync.isLoading || historyAsync.isLoading;
    final hasError = summaryAsync.hasError || historyAsync.hasError;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      // Crossfades the skeleton out as the data arrives instead of cutting to
      // it. The three states are distinct widget types, so the switcher
      // detects the change without explicit keys.
      child: AnimatedSwitcher(
        duration: AppMotion.duration(context, AppMotion.base),
        child: isLoading
            ? const _TotalAumTrendShimmer()
            : hasError
            ? const ErrorView(error: UnknownError())
            : _TotalAumTrendContent(
                summary: summaryAsync.requireValue,
                entries: historyAsync.requireValue,
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content
// ---------------------------------------------------------------------------

class _TotalAumTrendContent extends StatelessWidget {
  const _TotalAumTrendContent({required this.summary, required this.entries});

  final DashboardSummary summary;
  final List<FaAumEntry> entries;

  @override
  Widget build(BuildContext context) {
    return TouchReactiveAumHero<FaAumEntry>(
      eyebrowLabel: context.l10n.dashboardTotalAum,
      restValue: summary.totalAum,
      restLabel: context.l10n.dashboardHeroYtdLabel,
      entries: entries,
      filterProvider: aumFilterProvider,
      getDate: (e) => e.weekDate,
      getValue: (e) => e.aum,
      chartContext: HistoryChartContext.totalAum,
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer skeleton
// ---------------------------------------------------------------------------

/// Placeholder skeleton displayed while AUM history is loading.
class _TotalAumTrendShimmer extends StatelessWidget {
  const _TotalAumTrendShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Shimmer.fromColors(
      baseColor: colors.bgPrimary,
      highlightColor: colors.surfaceDefault,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label — Inter 14px, ~×1.2 natural line height ≈ 17 → 18
          _ShimmerBox(width: 80, height: 18, colors: colors),
          const SizedBox(height: 6),
          // Hero value — Inter 28px, ~×1.2 ≈ 33.6 → 34
          _ShimmerBox(width: 220, height: 34, colors: colors),
          const SizedBox(height: 8),
          // Change row — Inter 16px, ~×1.2 ≈ 19.2 → 20
          Row(
            children: [
              _ShimmerBox(width: 120, height: 20, colors: colors),
              const SizedBox(width: 8),
              _ShimmerBox(width: 40, height: 20, colors: colors),
            ],
          ),
          const SizedBox(height: 16),
          _ShimmerBox(width: double.infinity, height: 64, radius: 8, colors: colors),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ShimmerBox(width: 52, height: 28, radius: 20, colors: colors),
              const SizedBox(width: 8),
              _ShimmerBox(width: 52, height: 28, radius: 20, colors: colors),
              const SizedBox(width: 8),
              _ShimmerBox(width: 52, height: 28, radius: 20, colors: colors),
              const SizedBox(width: 8),
              _ShimmerBox(width: 52, height: 28, radius: 20, colors: colors),
            ],
          ),
          const SizedBox(height: 10),
          // _ChartInfo — Inter 12px × lineHeight 1.4 = 16.8 → 17 per line; text wraps to ~2 lines
          _ShimmerBox(width: double.infinity, height: 15, colors: colors),
          const SizedBox(height: 3),
          _ShimmerBox(width: 160, height: 15, colors: colors),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.colors,
    this.radius = 4,
  });
  final double width;
  final double height;
  final double radius;
  final AppColorTokens colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
