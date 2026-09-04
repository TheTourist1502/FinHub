import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Hairline rule separating sections, with 24 px breathing room on both sides.
class ServiceRequestSectionDivider extends StatelessWidget {
  /// Creates a [ServiceRequestSectionDivider].
  const ServiceRequestSectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceMd),
      child: Container(height: 1, color: context.appColors.borderSubtle),
    );
  }
}
