import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Canonical set of risk profiles an account can carry.
///
/// The backend exposes two different scales, and which one comes back depends
/// on the environment:
///
/// * **Production** returns the full label, from one of two scales —
///   `Low Risk` → `Moderate Risk` → `High Risk` → `Speculative`, or
///   `Conservative` → `Moderately Conservative` → `Moderate` →
///   `Moderately Aggressive` → `Significant Risk`.
/// * **Development** returns the shorthand `low`, `medium`, `high` or
///   `Speculative`, which maps onto the first scale above.
///
/// [RiskProfile.tryParse] folds every one of those spellings into a single
/// member so the UI only ever deals with the production labels.
enum RiskProfile {
  /// Least risk on the `Low`/`Moderate`/`High`/`Speculative` scale.
  lowRisk,

  /// Middle of the `Low`/`Moderate`/`High`/`Speculative` scale.
  moderateRisk,

  /// Second-highest on the `Low`/`Moderate`/`High`/`Speculative` scale.
  highRisk,

  /// Most risk on the `Low`/`Moderate`/`High`/`Speculative` scale.
  speculative,

  /// Least risk on the `Conservative` → `Significant Risk` scale.
  conservative,

  /// Second-lowest on the `Conservative` → `Significant Risk` scale.
  moderatelyConservative,

  /// Middle of the `Conservative` → `Significant Risk` scale.
  moderate,

  /// Second-highest on the `Conservative` → `Significant Risk` scale.
  moderatelyAggressive,

  /// Most risk on the `Conservative` → `Significant Risk` scale.
  significantRisk,

  /// Growth mandate — sits outside both severity scales.
  growth;

  /// Resolves a raw backend value to a [RiskProfile], or `null` when the value
  /// is unrecognised.
  ///
  /// Matching ignores case, spacing and separators, so `Moderately Aggressive`,
  /// `moderately_aggressive` and `MODERATELY-AGGRESSIVE` all resolve to the
  /// same member.
  static RiskProfile? tryParse(String raw) => _aliases[raw.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '')];

  /// Every accepted spelling, normalised, mapped to its canonical member.
  static const Map<String, RiskProfile> _aliases = {
    'lowrisk': RiskProfile.lowRisk,
    'low': RiskProfile.lowRisk,
    'moderaterisk': RiskProfile.moderateRisk,
    'medium': RiskProfile.moderateRisk,
    'highrisk': RiskProfile.highRisk,
    'high': RiskProfile.highRisk,
    'speculative': RiskProfile.speculative,
    'conservative': RiskProfile.conservative,
    'moderatelyconservative': RiskProfile.moderatelyConservative,
    'moderateconservative': RiskProfile.moderatelyConservative,
    'moderate': RiskProfile.moderate,
    'moderatelyaggressive': RiskProfile.moderatelyAggressive,
    'moderateaggressive': RiskProfile.moderatelyAggressive,
    'aggressive': RiskProfile.moderatelyAggressive,
    'significantrisk': RiskProfile.significantRisk,
    'growth': RiskProfile.growth,
  };

  /// Localised display label for this profile.
  String label(AppLocalizations l10n) => switch (this) {
    RiskProfile.lowRisk => l10n.riskProfileLowRisk,
    RiskProfile.moderateRisk => l10n.riskProfileModerateRisk,
    RiskProfile.highRisk => l10n.riskProfileHighRisk,
    RiskProfile.speculative => l10n.riskProfileSpeculative,
    RiskProfile.conservative => l10n.riskProfileConservative,
    RiskProfile.moderatelyConservative => l10n.riskProfileModeratelyConservative,
    RiskProfile.moderate => l10n.riskProfileModerate,
    RiskProfile.moderatelyAggressive => l10n.riskProfileModeratelyAggressive,
    RiskProfile.significantRisk => l10n.riskProfileSignificantRisk,
    RiskProfile.growth => l10n.riskProfileGrowth,
  };

  /// Badge foreground for the given [brightness].
  ///
  /// Every profile owns its own hue — no two badges are ever the same colour —
  /// while each scale still walks a green → red severity arc.
  Color foreground(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return switch (this) {
      RiskProfile.conservative => isDark ? AppColors.riskConservativeDark : AppColors.riskConservativeLight,
      RiskProfile.moderatelyConservative =>
        isDark ? AppColors.riskModeratelyConservativeDark : AppColors.riskModeratelyConservativeLight,
      RiskProfile.moderate => isDark ? AppColors.riskModerateDark : AppColors.riskModerateLight,
      RiskProfile.moderatelyAggressive =>
        isDark ? AppColors.riskModeratelyAggressiveDark : AppColors.riskModeratelyAggressiveLight,
      RiskProfile.significantRisk => isDark ? AppColors.riskSignificantDark : AppColors.riskSignificantLight,
      RiskProfile.lowRisk => isDark ? AppColors.riskLowDark : AppColors.riskLowLight,
      RiskProfile.moderateRisk => isDark ? AppColors.riskModerateRiskDark : AppColors.riskModerateRiskLight,
      RiskProfile.highRisk => isDark ? AppColors.riskHighDark : AppColors.riskHighLight,
      RiskProfile.speculative => isDark ? AppColors.riskSpeculativeDark : AppColors.riskSpeculativeLight,
      RiskProfile.growth => isDark ? AppColors.brandSkyBlue : AppColors.brandNavyBlue,
    };
  }
}

/// Risk-profile pill badge with colour-coded fill.
///
/// Accepts the raw backend string and resolves it via [RiskProfile.tryParse].
/// Unrecognised values still render — uppercased, in the disabled palette —
/// so a new backend value degrades visibly rather than disappearing.
class RiskBadge extends StatelessWidget {
  /// Creates a badge for the raw [riskProfile] value returned by the backend.
  const RiskBadge({required this.riskProfile, super.key});

  /// Raw risk-profile value, e.g. `Moderately Aggressive` or `high`.
  final String riskProfile;

  /// Opacity applied to the foreground colour to derive the pill fill. Tinting
  /// rather than hardcoding a fill keeps the badge legible on both the light
  /// and dark card surfaces.
  static const double _fillOpacity = 0.15;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final profile = RiskProfile.tryParse(riskProfile);

    final foreground = profile?.foreground(Theme.of(context).brightness) ?? colors.textDisabled;
    final background = profile == null ? colors.surfaceDisabled : foreground.withValues(alpha: _fillOpacity);
    final label = profile?.label(context.l10n) ?? riskProfile;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }
}
