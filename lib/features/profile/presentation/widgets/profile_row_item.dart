import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// A single list row used inside profile section cards.
///
/// Renders a 34×34 icon box on the left, a title + subtitle column in the
/// centre, and an optional trailing widget on the right.
class ProfileRowItem extends StatelessWidget {
  /// Creates a [ProfileRowItem].
  ///
  /// [iconWidget] is rendered centred inside a 34×34 rounded-8 container
  /// with background colour [iconBgColor].
  const ProfileRowItem({
    required this.iconWidget,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    super.key,
  });

  /// Widget rendered inside the coloured icon box (typically an icon widget).
  final Widget iconWidget;

  /// Background colour of the 34×34 icon container.
  final Color iconBgColor;

  final String title;
  final String subtitle;

  /// Optional trailing widget (e.g. a status badge or chevron).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(8)),
            child: Center(child: iconWidget),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: context.appColors.textSecondary),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
