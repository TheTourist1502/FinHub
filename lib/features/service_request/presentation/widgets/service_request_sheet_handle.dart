import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Grab-handle pill drawn at the top of the service request detail sheet.
class ServiceRequestSheetHandle extends StatelessWidget {
  /// Creates a [ServiceRequestSheetHandle].
  const ServiceRequestSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceMd),
      child: Container(
        width: 48,
        height: 4,
        decoration: BoxDecoration(
          color: context.appColors.borderDefault,
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
    );
  }
}
