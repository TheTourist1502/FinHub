import 'package:cached_network_image/cached_network_image.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Small circular avatar shared by [PageAppBar] and the home-shell header bar.
///
/// Renders [avatarUrl] via [CachedNetworkImage] when present and non-empty;
/// falls back to [initials] on [backgroundColor] otherwise (also shown while
/// the image is loading or fails to load).
class UserAvatarBadge extends StatelessWidget {
  /// Creates a [UserAvatarBadge].
  const UserAvatarBadge({
    required this.initials,
    this.avatarUrl,
    this.size = 32,
    this.backgroundColor,
    this.textColor,
    this.onImageError,
    this.initialsBorderColor,
    this.initialsBorderWidth = 1,
    super.key,
  });

  /// Fallback initials shown when [avatarUrl] is absent, loading, or failed.
  final String initials;

  /// Uploaded avatar URL; null or empty shows [initials] instead.
  final String? avatarUrl;

  /// Diameter of the circular badge.
  final double size;

  /// Defaults to `Theme.of(context).colorScheme.primary`.
  final Color? backgroundColor;

  /// Defaults to `context.appColors.textOnAccent`.
  final Color? textColor;

  /// Invoked once when [avatarUrl] fails to load (e.g. an expired pre-signed
  /// URL). Callers wire this to a profile refresh; kept as a plain callback
  /// so this widget stays prop-driven with no direct Riverpod dependency.
  final VoidCallback? onImageError;

  /// Ring drawn around the initials when no picture is shown; `null` for none.
  ///
  /// Deliberately not drawn over a picture: a photo already reads as an
  /// avatar, whereas initials on a pale fill need the outline to hold the
  /// circle's edge.
  final Color? initialsBorderColor;

  /// Thickness of [initialsBorderColor]; ignored when that is `null`.
  final double initialsBorderWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    final initialsText = Center(
      child: Text(
        initials,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: size * 0.375,
          fontWeight: FontWeight.w600,
          color: textColor ?? colors.textOnAccent,
        ),
      ),
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? cs.primary,
        shape: BoxShape.circle,
        border: (!hasAvatar && initialsBorderColor != null)
            ? Border.all(color: initialsBorderColor!, width: initialsBorderWidth)
            : null,
      ),
      child: hasAvatar
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: avatarUrl!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                placeholder: (_, _) => initialsText,
                errorWidget: (_, _, _) {
                  onImageError?.call();
                  return initialsText;
                },
              ),
            )
          : initialsText,
    );
  }
}
