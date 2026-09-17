import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/welcome/presentation/providers/welcome_provider.dart';
import 'package:flutter/material.dart';

/// Pagination dots for the welcome carousel — one 8x8 dot per page, the
/// active page rendered in [AppColorTokens.interactiveDefault].
class WelcomePageDots extends StatelessWidget {
  /// Creates a [WelcomePageDots].
  const WelcomePageDots({required this.activeIndex, super.key});

  /// Index of the currently visible page.
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < kWelcomePageCount; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == activeIndex ? colors.interactiveDefault : colors.interactiveDisabled,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ],
    );
  }
}
