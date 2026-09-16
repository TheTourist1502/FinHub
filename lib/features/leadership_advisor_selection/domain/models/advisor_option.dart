import 'package:flutter/foundation.dart';

/// A single financial advisor a leadership user may select as the active
/// data context for the app.
///
/// Built from `assets/mock-data/profile/advisors.json`, which mirrors the
/// shape `GET /v1/profile/leadership/advisors` returned. [fullName] can
/// repeat across different [financialAdvisorId] values — never key list items
/// on it.
@immutable
class AdvisorOption {
  /// Creates an [AdvisorOption] with all required fields.
  const AdvisorOption({
    required this.financialAdvisorId,
    required this.companyEmail,
    required this.fullName,
    this.avatarUrl,
  });

  /// Creates an [AdvisorOption] from a fixture row.
  factory AdvisorOption.fromJson(Map<String, dynamic> json) {
    final avatarUrl = json['avatarUrl'] as String?;
    return AdvisorOption(
      financialAdvisorId: json['financialAdvisorId'] as String,
      companyEmail: json['companyEmail'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      avatarUrl: (avatarUrl == null || avatarUrl.isEmpty) ? null : avatarUrl,
    );
  }

  /// Identifier of the advisor, matching [User.advisorId] of the advisors it
  /// names — the only field guaranteed unique.
  final String financialAdvisorId;

  /// The advisor's FinHub email address.
  final String companyEmail;

  /// The advisor's display name, verbatim from the fixture.
  final String fullName;

  /// Profile picture URL, or `null` when they have not uploaded one.
  final String? avatarUrl;

  /// Equality covers the three stable fields only — [avatarUrl] is excluded,
  /// mirroring how a real pre-signed URL would rotate without the advisor's
  /// identity changing.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdvisorOption &&
          runtimeType == other.runtimeType &&
          financialAdvisorId == other.financialAdvisorId &&
          companyEmail == other.companyEmail &&
          fullName == other.fullName;

  @override
  int get hashCode => Object.hash(financialAdvisorId, companyEmail, fullName);

  @override
  String toString() => 'AdvisorOption(financialAdvisorId: $financialAdvisorId, fullName: $fullName)';
}
