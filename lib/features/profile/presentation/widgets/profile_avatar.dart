import 'package:finhub/shared/widgets/layout/user_avatar_badge.dart';
import 'package:flutter/material.dart';

/// Circular 64×64 profile avatar with an initials fallback (via
/// [UserAvatarBadge]) when no [avatarUrl] is set. Display-only — this build
/// has no storage to upload a new photo to.
class ProfileAvatar extends StatelessWidget {
  /// Creates a [ProfileAvatar].
  const ProfileAvatar({required this.displayName, this.avatarUrl, super.key});

  /// User's display name, used to derive the initials fallback.
  final String displayName;

  /// Avatar URL; `null` or empty shows the initials fallback instead.
  final String? avatarUrl;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'[\s.]+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 64,
      height: 64,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: cs.primary, width: 2)),
      child: UserAvatarBadge(initials: _initials(displayName), avatarUrl: avatarUrl, size: 56),
    );
  }
}
