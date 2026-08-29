import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:flutter/material.dart';

/// Height matching a rendered household card, shared with the loading shimmer.
const double kHouseholdsInsightsCardHeight = 140;

/// Empty-state card shown when the advisor has no households.
///
/// Mirrors the household card's background, border and height.
class HouseholdsInsightsEmptyCard extends StatelessWidget {
  /// Creates a [HouseholdsInsightsEmptyCard].
  const HouseholdsInsightsEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      height: kHouseholdsInsightsCardHeight,
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
      ),
      // scaleDown keeps the illustration inside the fixed height on wide
      // screens, where a screen-width fraction would overflow vertically.
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        child: NoRecordWidget(widthFactor: 0.15),
      ),
    );
  }
}
