import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// "ACTIVITY DESCRIPTION" label with the activity's description beneath it,
/// closing an activity card.
class RealTimeTransactionsActivityNote extends StatelessWidget {
  /// Creates a [RealTimeTransactionsActivityNote] for [description].
  const RealTimeTransactionsActivityNote({required this.description, super.key});

  /// The activity description text from the source data.
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.realTimeAccountActivityLabel,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.metricLabelMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: context.appColors.textSecondary,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}
