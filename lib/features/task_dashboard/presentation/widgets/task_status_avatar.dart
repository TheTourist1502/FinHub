import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/widgets/status/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

/// Circular badge carrying the glyph for a task's workflow stage.
///
/// Takes the raw API string so callers never parse: the stage picks the glyph
/// via [getIconByLabel], while the circle keeps one fixed info-toned
/// treatment — the stage is already spelled out by the chip beside it, so
/// tinting the avatar per stage would only compete with it.
///
/// Shared by the task list card and the task detail sheet, so tapping through
/// from the list never swaps the avatar out from under the user.
class TaskStatusAvatar extends StatelessWidget {
  /// Creates a [TaskStatusAvatar] for the raw API [status] text.
  const TaskStatusAvatar({
    required this.status,
    this.size = 48,
    this.iconSize,
    this.fallbackIcon,
    super.key,
  });

  /// Raw workflow status text from the API (e.g. "Pending Ops Review").
  final String? status;

  /// Diameter of the circle.
  final double size;

  /// Glyph size; defaults to half [size].
  final double? iconSize;

  /// Glyph used when [status] names no known stage — lets a caller with a
  /// better icon of its own (e.g. the task's record type) supply it instead of
  /// the question mark.
  final String? fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colors.statusInfoBg, shape: BoxShape.circle),
      child: Iconify(
        getIconByLabel(status, fallback: fallbackIcon ?? kStatusFallbackIcon),
        color: colors.interactiveDefault,
        size: iconSize ?? size / 2,
      ),
    );
  }
}
