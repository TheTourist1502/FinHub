import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Button that skips the countdown and goes to the service requests home page.
class ServiceRequestSuccessActionButton extends StatelessWidget {
  /// Creates a [ServiceRequestSuccessActionButton].
  const ServiceRequestSuccessActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => context.go(AppRoutes.serviceRequests),
      style: FilledButton.styleFrom(
        backgroundColor: context.appColors.bgBrandNavyBlue,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        context.l10n.serviceRequestSuccessGoButton,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
