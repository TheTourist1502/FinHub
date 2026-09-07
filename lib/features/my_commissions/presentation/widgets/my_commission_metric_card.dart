import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

/// A KPI metric tile shown on the My Commissions overview tab — an icon
/// badge, a prominent count, and a two-line label/sublabel pair (e.g.
/// "12" / "Households" / "Contributing").
class MyCommissionMetricCard extends StatelessWidget {
  /// Creates a [MyCommissionMetricCard].
  const MyCommissionMetricCard({
    required this.icon,
    required this.count,
    required this.label,
    required this.sublabel,
    super.key,
  });

  /// MDI SVG string for the icon shown in the circle.
  final String icon;

  /// The numeric count value displayed prominently.
  final int count;

  /// Primary label below the count (e.g. "Households").
  final String label;

  /// Secondary label below the primary (e.g. "Contributing").
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.statusInfoBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Iconify(icon, size: 20, color: colors.interactiveDefault),
          ),
          const SizedBox(height: 8),
          // Counts up from zero rather than from a fraction of the figure: the
          // column is centred and the number is small, so a changing digit
          // count re-centres instead of shuffling the card's other rows.
          FigureReveal(
            duration: AppMotion.settle,
            builder: (context, t) => Text(
              '${(count * t).round()}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: colors.textPrimary,
                height: 28 / 20,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: colors.textPrimary,
              height: 16 / 12,
            ),
          ),
          Text(
            sublabel,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: colors.textSecondary,
              height: 15 / 10,
            ),
          ),
        ],
      ),
    );
  }
}
