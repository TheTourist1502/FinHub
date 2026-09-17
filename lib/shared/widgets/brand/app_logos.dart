import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// The app's mark (`Mdi.finance`) beside its name, styled per
/// `AppTypography.logoStyle`. There is no logo image asset — every screen
/// that needs the brand uses this widget rather than a raw `Iconify`.
///
/// [width] scales the whole mark down to fit a fixed slot (e.g. the welcome
/// carousel); left `null` it renders at its intrinsic size, matching the
/// sign-in screen's fixed-size header.
class AppWordmarkLogo extends StatelessWidget {
  /// Creates an [AppWordmarkLogo].
  const AppWordmarkLogo({this.width, super.key});

  /// Target width to scale down to, or `null` for intrinsic size.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final mark = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Iconify(Mdi.finance, color: colors.textBrandNavyBlue, size: 40),
        const SizedBox(width: AppDimensions.spaceSm),
        Text(context.l10n.appName, style: AppTypography.logoStyle.copyWith(color: colors.textPrimary)),
      ],
    );
    final width = this.width;
    if (width == null) return mark;
    return SizedBox(width: width, child: FittedBox(fit: BoxFit.scaleDown, child: mark));
  }
}
