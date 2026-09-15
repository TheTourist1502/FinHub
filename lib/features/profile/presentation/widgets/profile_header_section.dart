import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/roles/user_role_label.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/login/domain/models/user.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:finhub/features/profile/domain/models/profile_data.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:finhub/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Displays the authenticated user's avatar (initials), full name, verified
/// badge, and role badge at the top of the Profile screen.
///
/// Watches [currentUserProvider] for the signed-in session and
/// [currentProfileProvider] for the fixture-backed profile record — the
/// header still renders (with the session's own name) while the profile
/// fetch is in flight.
class ProfileHeaderSection extends ConsumerWidget {
  /// Creates a [ProfileHeaderSection].
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();
    final profile = ref.watch(currentProfileProvider).value;
    return _HeaderContent(user: user, profile: profile);
  }
}

/// Rendered once [currentUserProvider] has resolved with a valid [User].
class _HeaderContent extends StatelessWidget {
  const _HeaderContent({required this.user, this.profile});

  final User user;

  /// Profile data used for the role badge; may be null while loading.
  final ProfileData? profile;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;

    final displayName = (profile != null && profile!.fullName.isNotEmpty) ? profile!.fullName : user.name;
    final role = profile?.role ?? '';
    final isActive = profile?.isActive ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileAvatar(displayName: displayName, avatarUrl: profile?.avatarUrl),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          letterSpacing: -0.5,
                          height: 28 / 20,
                        ),
                      ),
                    ),
                    if (isActive) ...[const SizedBox(width: 6), Iconify(Mdi.shield_check, size: 16, color: cs.primary)],
                  ],
                ),
                const SizedBox(height: 6),
                if (role.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      context.l10n.profileRoleBadge(_roleLabel(context, role)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: colors.textSecondary),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Maps the fixture's raw role string (e.g. `"advisor"`) to its localised
  /// display name, falling back to the raw value for anything unrecognised.
  String _roleLabel(BuildContext context, String rawRole) => UserRole.tryParse(rawRole)?.label(context.l10n) ?? rawRole;
}
