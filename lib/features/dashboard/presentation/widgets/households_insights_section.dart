import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:finhub/features/dashboard/presentation/widgets/households_insights_header.dart';
import 'package:finhub/features/dashboard/presentation/widgets/households_insights_list.dart';
import 'package:finhub/features/dashboard/presentation/widgets/households_insights_shimmer.dart';
import 'package:finhub/shared/widgets/feedback/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dashboard section listing the top households by AUM as horizontal cards.
///
/// Loads data via [householdsProvider] and swaps in shimmer or error states.
class HouseholdsInsightsSection extends ConsumerWidget {
  /// Creates a [HouseholdsInsightsSection].
  const HouseholdsInsightsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Crossfades the skeleton out as the data arrives instead of cutting to
    // it. The three states are distinct widget types, so the switcher detects
    // the change without explicit keys.
    return AnimatedSwitcher(
      duration: AppMotion.duration(context, AppMotion.base),
      child: ref
          .watch(householdsProvider)
          .when(
            skipLoadingOnRefresh: false,
            loading: () => const HouseholdsInsightsShimmer(),
            error: (e, _) => const ErrorView(error: UnknownError()),
            data: (households) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HouseholdsInsightsHeader(householdCount: households.length),
                const SizedBox(height: 12),
                HouseholdsInsightsList(households: households),
              ],
            ),
          ),
    );
  }
}
