import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// One `Label : value` line of the detail sheet, the label muted at w400 and
/// the value carried at w500 in the primary colour.
///
/// [label] supplies its own separator (e.g. `Account Number :`) so the
/// punctuation can vary by locale. Built as a single [Text.rich] rather than a
/// [Row] so a long value wraps under the label instead of overflowing.
Widget serviceRequestLabelledLine(BuildContext context, String label, String value) {
  final labelStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
    color: context.appColors.textSecondary,
  );

  return Text.rich(
    TextSpan(
      children: [
        TextSpan(text: '$label ', style: labelStyle),
        TextSpan(
          text: value,
          style: labelStyle.copyWith(fontWeight: FontWeight.w500, color: context.appColors.textPrimary),
        ),
      ],
    ),
  );
}

/// Titled block within the service request detail sheet.
///
/// [gap] lets each caller keep its own Figma spacing between title and body.
class ServiceRequestDetailSection extends StatelessWidget {
  /// Creates a [ServiceRequestDetailSection] with [title] above [child].
  const ServiceRequestDetailSection({required this.title, required this.child, this.gap = 3.25, super.key});

  /// Localised section heading.
  final String title;

  /// Section body rendered under the heading.
  final Widget child;

  /// Vertical space between the heading and [child].
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 24 / 16,
            color: context.appColors.textPrimary,
          ),
        ),
        SizedBox(height: gap),
        child,
      ],
    );
  }
}
