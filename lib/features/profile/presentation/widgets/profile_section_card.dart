import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Reusable card container used throughout the Profile screen.
///
/// Provides a consistent adaptive background, 16dp rounded corners, a subtle
/// border, and a 1px drop shadow shared by every profile section card.
class ProfileSectionCard extends StatelessWidget {
  /// Creates a [ProfileSectionCard] wrapping [child].
  const ProfileSectionCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.appColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 2, offset: Offset(0, 1))],
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }
}

/// Uppercase section label rendered above each [ProfileSectionCard].
class ProfileSectionHeader extends StatelessWidget {
  /// Creates a [ProfileSectionHeader] with the given [label].
  const ProfileSectionHeader({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: context.appColors.textSecondary,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}
