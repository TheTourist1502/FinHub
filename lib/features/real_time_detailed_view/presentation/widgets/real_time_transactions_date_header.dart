import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Uppercase snapshot header above a run of same-batch activities.
/// Callers pass already-formatted text.
class RealTimeTransactionsDateHeader extends StatelessWidget {
  /// Creates a [RealTimeTransactionsDateHeader] showing [label].
  const RealTimeTransactionsDateHeader({required this.label, super.key});

  /// Pre-formatted, already-localised header text.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: context.appColors.textSecondary,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
