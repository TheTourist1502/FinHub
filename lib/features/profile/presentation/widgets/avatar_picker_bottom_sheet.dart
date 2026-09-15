import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/profile/presentation/widgets/preference_selection_option.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:image_picker/image_picker.dart';

/// Shows a bottom sheet offering "Take Photo" and "Choose from Gallery"
/// options for updating the profile avatar.
///
/// Returns the selected [ImageSource], or `null` if the sheet was dismissed
/// without a selection.
Future<ImageSource?> showAvatarPickerBottomSheet(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
    builder: (_) => const _AvatarPickerSheet(),
  );
}

class _AvatarPickerSheet extends StatelessWidget {
  const _AvatarPickerSheet();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PreferenceBottomSheetHeader(title: context.l10n.profileAvatarPickerTitle),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: Column(
            children: [
              _AvatarSourceOption(
                icon: Mdi.camera_outline,
                label: context.l10n.profileAvatarTakePhoto,
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              const SizedBox(height: 8),
              _AvatarSourceOption(
                icon: Mdi.image_outline,
                label: context.l10n.profileAvatarChooseFromGallery,
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Single tappable row inside [_AvatarPickerSheet] — icon + label on a
/// tinted rounded background.
class _AvatarSourceOption extends StatelessWidget {
  const _AvatarSourceOption({required this.icon, required this.label, required this.onTap});

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: colors.statusInfoBg, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Iconify(icon, size: 20, color: cs.primary),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: cs.onSurface)),
          ],
        ),
      ),
    );
  }
}
