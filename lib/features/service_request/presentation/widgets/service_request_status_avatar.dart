import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/widgets/status/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

/// Circular badge carrying the glyph for a service request's workflow stage.
///
/// Takes the raw API string so callers never parse: the stage picks the glyph
/// via [getIconByLabel], while the circle keeps one fixed info-toned
/// treatment — the stage is already spelled out by the chip beside it, so
/// tinting the avatar per stage would only compete with it.
///
/// Shared by the request list card and the request detail sheet, so tapping
/// through from the list never swaps the avatar out from under the user.
class ServiceRequestStatusAvatar extends StatelessWidget {
  /// Creates a [ServiceRequestStatusAvatar] for the raw API [status] text.
  const ServiceRequestStatusAvatar({required this.status, this.size = 48, this.iconSize, super.key});

  /// Raw workflow status text from the API (e.g. "Pending Ops Review").
  final String? status;

  /// Diameter of the circle.
  final double size;

  /// Glyph size; defaults to half [size].
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colors.statusInfoBg, shape: BoxShape.circle),
      child: Iconify(
        getIconByLabel(status),
        color: colors.interactiveDefault,
        size: iconSize ?? size / 2,
      ),
    );
  }
}
