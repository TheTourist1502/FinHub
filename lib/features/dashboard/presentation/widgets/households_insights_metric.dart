import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Label-over-value column used for the AUM and YTD figures on a household card.
///
/// Extracted because both figures render identically apart from the value color.
class HouseholdsInsightsMetric extends StatelessWidget {
  /// Creates a [HouseholdsInsightsMetric].
  const HouseholdsInsightsMetric({required this.label, required this.value, this.valueColor, super.key});

  /// Localised caption shown above the value.
  final String label;

  /// Formatted figure shown below the label.
  final String value;

  /// Value color; falls back to the primary text token when null.
  final Color? valueColor;

  /// Caption style; color is applied per theme in [build].
  static const TextStyle _labelStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.33,
  );

  /// Figure style; color is applied per theme in [build].
  static const TextStyle _valueStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: _valueStyle.copyWith(color: valueColor ?? colors.textPrimary)),
      ],
    );
  }
}
