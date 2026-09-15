import 'dart:io';

import 'package:finhub/core/feedback/snackbar_service.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:finhub/features/profile/presentation/widgets/avatar_picker_bottom_sheet.dart';
import 'package:finhub/shared/widgets/layout/user_avatar_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/// Client-side avatar size limit, checked before upload so an oversized crop
/// is rejected without a round trip.
const int _kMaxAvatarBytes = 2 * 1024 * 1024;

/// Circular 64×64 profile avatar with an initials fallback (via
/// [UserAvatarBadge]) and a camera badge for changing the photo.
///
/// Tapping the badge opens [showAvatarPickerBottomSheet] to pick a source,
/// crops the result to a square via `image_cropper`, rejects it client-side
/// if it exceeds [_kMaxAvatarBytes], then hands it to
/// [AvatarUploadNotifier.uploadAvatar]. A spinner overlays the avatar while
/// [avatarUploadProvider] is loading — independent of the preference rows'
/// own loaders.
class ProfileAvatar extends ConsumerWidget {
  /// Creates a [ProfileAvatar].
  const ProfileAvatar({required this.displayName, this.avatarUrl, super.key});

  /// User's display name, used to derive the initials fallback.
  final String displayName;

  /// Uploaded avatar URL; `null` or empty shows the initials fallback instead.
  final String? avatarUrl;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'[\s.]+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final isUploading = ref.watch(avatarUploadProvider).isLoading;

    return Stack(
      children: [
        Container(
          width: 64,
          height: 64,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: cs.primary, width: 2)),
          child: UserAvatarBadge(initials: _initials(displayName), avatarUrl: avatarUrl, size: 56),
        ),
        if (isUploading)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black.withAlpha(90), shape: BoxShape.circle),
              child: const Center(
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: isUploading ? null : () => _pickAndUpload(context, ref),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
                border: Border.all(color: colors.surfaceDefault, width: 2),
              ),
              child: const Center(child: Iconify(Mdi.camera, size: 12, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickAndUpload(BuildContext context, WidgetRef ref) async {
    final source = await showAvatarPickerBottomSheet(context);
    if (source == null || !context.mounted) return;

    XFile? picked;
    try {
      picked = await ImagePicker().pickImage(source: source, imageQuality: 90);
    } on Object catch (e, s) {
      AppLogger.e('ProfileAvatar.pickImage failed', e, s);
      return;
    }
    if (picked == null || !context.mounted) return;

    final cropped = await _cropImage(context, picked.path);
    if (cropped == null || !context.mounted) return;

    final file = File(cropped.path);
    final fileSize = await file.length();
    if (!context.mounted) return;
    if (fileSize > _kMaxAvatarBytes) {
      ref.read(snackbarServiceProvider).showError(context.l10n.profileAvatarTooLarge);
      return;
    }

    await ref.read(avatarUploadProvider.notifier).uploadAvatar(file);
    if (!context.mounted) return;
    if (ref.read(avatarUploadProvider).hasError) {
      ref.read(snackbarServiceProvider).showError(context.l10n.profileAvatarUploadError);
    } else {
      ref.read(snackbarServiceProvider).showSuccess(context.l10n.profileAvatarUploadSuccess);
    }
  }

  Future<CroppedFile?> _cropImage(BuildContext context, String sourcePath) {
    final cs = Theme.of(context).colorScheme;
    return ImageCropper().cropImage(
      sourcePath: sourcePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      maxWidth: 1024,
      maxHeight: 1024,
      compressQuality: 85,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: context.l10n.profileAvatarCropTitle,
          toolbarColor: cs.primary,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: context.l10n.profileAvatarCropTitle, aspectRatioLockEnabled: true),
      ],
    );
  }
}
