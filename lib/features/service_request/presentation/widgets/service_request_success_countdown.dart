import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Tells the user how many seconds remain before the auto-redirect.
///
/// Kept separate so the per-second tick repaints only this line.
class ServiceRequestSuccessCountdown extends StatelessWidget {
  /// Creates a [ServiceRequestSuccessCountdown].
  const ServiceRequestSuccessCountdown({required this.secondsRemaining, super.key});

  /// Seconds left on the redirect timer.
  final int secondsRemaining;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: colors.textSecondary),
        children: [
          TextSpan(text: l10n.serviceRequestSuccessRedirectPrefix),
          TextSpan(
            text: secondsRemaining.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: colors.textPrimary,
            ),
          ),
          TextSpan(text: l10n.serviceRequestSuccessRedirectSuffix),
        ],
      ),
    );
  }
}
