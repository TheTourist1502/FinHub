import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/login/domain/models/user.dart';

/// Localised display name for a [UserRole].
///
/// `UserRole.name` is the token's claim value and is never shown to a user.
extension UserRoleLabel on UserRole {
  /// Returns this role's display name in the active locale.
  String label(AppLocalizations l10n) => switch (this) {
    UserRole.advisor => l10n.roleAdvisor,
    UserRole.leadership => l10n.roleLeadership,
  };
}
