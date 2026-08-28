import 'dart:ui';

import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

/// Reusable confirmation dialog with customizable content and actions.
///
/// Displays a centered modal with:
/// - Icon badge (56x56, configurable color)
/// - Title and subtitle text
/// - Two action buttons (accept primary, reject secondary)
/// - Blurred dark backdrop
///
/// Returns `true` if accept button tapped; `false` for reject, barrier tap, or dismissal.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String? icon,
  required String title,
  required String subtitle,
  required String acceptLabel,
  required String rejectLabel,
  Color? iconBackgroundColor,
  VoidCallback? onAccept,
  VoidCallback? onReject,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (_) => _ConfirmDialog(
      icon: icon,
      title: title,
      subtitle: subtitle,
      acceptLabel: acceptLabel,
      rejectLabel: rejectLabel,
      iconBackgroundColor: iconBackgroundColor,
      onAccept: onAccept,
      onReject: onReject,
    ),
  );

  if (confirmed == true) {
    onAccept?.call();
  } else {
    onReject?.call();
  }

  return confirmed ?? false;
}

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.acceptLabel,
    required this.rejectLabel,
    this.iconBackgroundColor,
    this.onAccept,
    this.onReject,
  });

  final String? icon;
  final String title;
  final String subtitle;
  final String acceptLabel;
  final String rejectLabel;
  final Color? iconBackgroundColor;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Stack(
      children: [
        // Blurred dark scrim
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(false),
              child: Container(color: Colors.black.withValues(alpha: 0.2)),
            ),
          ),
        ),
        // Modal card
        Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.85),
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            padding: EdgeInsets.all(screenWidth * 0.0625),
            decoration: BoxDecoration(
              color: colors.surfaceDefault,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.borderSubtle),
              boxShadow: [
                BoxShadow(
                  color: colors.bgOverlay.withValues(alpha: 0.1),
                  blurRadius: 25,
                  offset: const Offset(0, 20),
                ),
                BoxShadow(
                  color: colors.bgOverlay.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon badge
                if (icon != null)
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor ?? AppColors.purple50,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Iconify(
                        icon!,
                        color: colors.interactiveDefault,
                        size: 36,
                      ),
                    ),
                  ),
                if (icon != null) const SizedBox(height: 8),
                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.interactiveDefault,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                    height: 1.57,
                  ),
                ),
                const SizedBox(height: 20),
                // Action buttons
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.bgBrandNavyBlue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      acceptLabel,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: colors.surfaceDefault,
                      side: BorderSide(color: colors.borderStrong, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      rejectLabel,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
