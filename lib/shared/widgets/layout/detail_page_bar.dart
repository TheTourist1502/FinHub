import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// App bar for full-screen detail routes pushed over the bottom-nav shell.
///
/// A back arrow and a title, nothing else. Detail screens — account, household,
/// transaction history, commission detail — all use this one bar, so the header
/// is defined in a single place rather than per screen.
///
/// The header's notification bell and avatar are deliberately absent: they
/// belong to the shell's own bar, and leadership must never be shown the bell
/// here because its unread count is advisor-scoped.
class DetailPageBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [DetailPageBar] titled [label], invoking [onPrevious] on back.
  const DetailPageBar({required this.label, required this.onPrevious, super.key});

  /// Title text displayed next to the back arrow.
  final String label;

  /// Callback invoked when the user taps the back arrow.
  final VoidCallback onPrevious;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      height: preferredSize.height + topPad,
      padding: EdgeInsets.only(top: topPad, left: 16, right: 16),
      decoration: BoxDecoration(
        color: context.appColors.surfaceDefault,
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            InkWell(
              onTap: onPrevious,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Iconify(Mdi.arrow_left, color: cs.onSurface),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                  letterSpacing: 0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
