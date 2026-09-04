import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Headline confirming the service request was submitted.
class ServiceRequestSuccessHeadline extends StatelessWidget {
  /// Creates a [ServiceRequestSuccessHeadline].
  const ServiceRequestSuccessHeadline({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.serviceRequestSuccessTitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: context.appColors.textPrimary,
        height: 1.25,
        letterSpacing: -0.75,
      ),
    );
  }
}
