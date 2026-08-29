import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:finhub/shared/widgets/charts/history_chart_widget.dart';
import 'package:finhub/shared/widgets/currency/currency_hero_value.dart';
import 'package:finhub/shared/widgets/feedback/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

/// Dashboard section showing total commissions, period-over-period change,
/// an area line chart, and time-range filter chips.
///
/// Owns its own white surface card (12 px radius, shadow) with 16/20/16 px
/// padding — no container wrapping needed in the parent screen.
///
/// The hero value comes from [commissionSummaryProvider] (the authoritative
/// `totalCommission` from `GET /v1/dashboard/summary`) while the chart history
/// comes from [commissionHistoryProvider] (`GET /v1/commissions/history`).
class TotalCommissionsTrendSection extends ConsumerWidget {
  /// Creates a [TotalCommissionsTrendSection].
  const TotalCommissionsTrendSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final summaryAsync = ref.watch(commissionSummaryProvider);
    final historyAsync = ref.watch(commissionHistoryProvider);

    final isLoading = summaryAsync.isLoading || historyAsync.isLoading;
    final rawError = summaryAsync.error ?? historyAsync.error;
    final appError = rawError is AppError ? rawError : (rawError != null ? const UnknownError() : null);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
        // boxShadow: [
        //   BoxShadow(
        //     color: colors.cardShadow,
        //     blurRadius: 8,
        //     offset: const Offset(0, 2),
        //     spreadRadius: -2,
        //   ),
        // ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      // Crossfades the skeleton out as the data arrives instead of cutting to
      // it. The three states are distinct widget types, so the switcher
      // detects the change without explicit keys.
      child: AnimatedSwitcher(
        duration: AppMotion.duration(context, AppMotion.base),
        child: isLoading
            ? const _CommissionShimmer()
            : appError != null
            ? ErrorView(
                error: appError,
                onRetry: () {
                  ref
                    ..invalidate(commissionSummaryProvider)
                    ..invalidate(commissionHistoryProvider);
                },
              )
            : _CommissionContent(
                totalCommission: summaryAsync.requireValue,
                entries: historyAsync.requireValue,
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content
// ---------------------------------------------------------------------------

class _CommissionContent extends StatelessWidget {
  const _CommissionContent({
    required this.totalCommission,
    required this.entries,
  });

  final double totalCommission;
  final List<FaCommissionEntry> entries;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.dashboardTotalCommissions,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: colors.textSecondary,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            // This card sits below the fold, so the roll waits for the
            // reader to reach it rather than finishing unseen.
            CurrencyHeroValue(value: totalCommission, revealOnScroll: true),
            const SizedBox(width: 4),
            Text(
              context.l10n.dashboardHeroYtdLabel,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        HistoryChartSection<FaCommissionEntry>(
          showHeader: false,
          entries: entries,
          filterProvider: commissionFilterProvider,
          getDate: (e) => e.weekDate,
          getValue: (e) => e.commission,
          label: context.l10n.dashboardTotalCommissions,
          chartContext: HistoryChartContext.totalCommission,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer skeleton
// ---------------------------------------------------------------------------

class _CommissionShimmer extends StatelessWidget {
  const _CommissionShimmer();

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
          _ShimmerBox(width: 140, height: 18, colors: colors),
          const SizedBox(height: 6),
          // Hero value — Inter 28px, ~×1.2 ≈ 33.6 → 34
          _ShimmerBox(width: 180, height: 34, colors: colors),
          const SizedBox(height: 4),
          // Change row — Inter 16px, ~×1.2 ≈ 19.2 → 20
          _ShimmerBox(width: 130, height: 20, colors: colors),
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
          _ShimmerBox(width: double.infinity, height: 17, colors: colors),
          const SizedBox(height: 1),
          _ShimmerBox(width: 160, height: 17, colors: colors),
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
