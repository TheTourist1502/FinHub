import 'package:flutter/painting.dart';

/// Centralised colour palette for the FinHub app.
///
/// Divided into two sections:
///   1. **Primitive colors** — the raw design-system palette. These are the
///      source of truth and map 1-to-1 to the FinHub Design System site
///      (https://design-system.finhub.example/#primitive-colors).
///      Never reference primitives directly in widgets — use [AppColorTokens]
///      semantic tokens (accessed via `context.appColors`) instead.
///   2. **Legacy aliases** — kept for backward compatibility with existing
///      widget code. New code should use [AppColorTokens].
class AppColors {
  const AppColors._();

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORS — Brand
  // ---------------------------------------------------------------------------

  /// Deep navy, FinHub brand dark.
  static const Color brandNavyBlue = Color(0xFF0D1846);

  /// Pale ice blue, FinHub brand light.
  static const Color brandBoneBlue = Color(0xFFE7F1F3);

  /// FinHub signature cyan-blue.
  static const Color brandFinHubBlue = Color(0xFF00B3E6);

  /// Light sky blue, FinHub brand accent.
  static const Color brandSkyBlue = Color(0xFFA1E3FB);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORS — Blue scale
  // ---------------------------------------------------------------------------

  static const Color blue50 = Color(0xFFE9F4FE);
  static const Color blue100 = Color(0xFFD2F0FF);
  static const Color blue200 = Color(0xFFA1E3FB);
  static const Color blue300 = Color(0xFF00B7EB);
  static const Color blue400 = Color(0xFF0389C3);
  static const Color blue500 = Color(0xFF0666A4);
  static const Color blue600 = Color(0xFF003D66);

  /// Sits between blue600 and blue700; used as primary text/icon fg in light theme.
  static const Color blue650 = Color(0xFF142641);
  static const Color blue700 = Color(0xFF0E233F);
  static const Color blue800 = Color(0xFF021729);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORS — Primary scale
  // ---------------------------------------------------------------------------

  /// Lightest tint — status/banner backgrounds.
  static const Color primary100 = Color(0xFFC7EEFA);
  static const Color primary200 = Color(0xFF73D5F1);

  /// Base shade — matches [brandFinHubBlue].
  static const Color primary300 = Color(0xFF00B3E6);
  static const Color primary400 = Color(0xFF066D9E);

  /// Darkest shade — status/banner foreground text.
  static const Color primary500 = Color(0xFF094373);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORS — Neutral scale
  // ---------------------------------------------------------------------------

  /// Near-white filled-surface tint, lighter than [neutral50].
  static const Color neutral25 = Color(0xFFF9FAFB);

  static const Color neutral50 = Color(0xFFF6F5F9);
  static const Color neutral100 = Color(0xFFE6E6E8);
  static const Color neutral200 = Color(0xFFD7D7DB);
  static const Color neutral300 = Color(0xFFC1C1C6);
  static const Color neutral400 = Color(0xFFACACAD);
  static const Color neutral500 = Color(0xFF868A93);
  static const Color neutral600 = Color(0xFF52585E);
  static const Color neutral700 = Color(0xFF2C323A);
  static const Color neutral800 = Color(0xFF1C232D);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORS — Teal scale
  // ---------------------------------------------------------------------------

  static const Color teal100 = Color(0xFFC1EAE6);
  static const Color teal200 = Color(0xFF3ECEC6);
  static const Color teal300 = Color(0xFF31A49E);
  static const Color teal400 = Color(0xFF27827D);
  static const Color teal500 = Color(0xFF133E3C);

  /// Brighter teal than [teal300] — service-request success record ID and its
  /// copy icon. Sits outside the ramp, so do not substitute a neighbour.
  static const Color tealAccent = Color(0xFF0D9488);

  /// Cool slate used for the success-screen record ID caption text.
  static const Color slate700 = Color(0xFF334155);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORS — Gold scale
  // ---------------------------------------------------------------------------

  static const Color gold100 = Color(0xFFEFDCBF);
  static const Color gold200 = Color(0xFFD4B893);
  static const Color gold300 = Color(0xFFD2AB7A);
  static const Color gold400 = Color(0xFFAE916A);
  static const Color gold500 = Color(0xFF634927);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORS — Lime scale
  // ---------------------------------------------------------------------------

  static const Color lime50 = Color(0xFFECFDF5);
  static const Color lime100 = Color(0xFFD0E5CE);
  static const Color lime200 = Color(0xFFAAD493);
  static const Color lime300 = Color(0xFF79B858);
  static const Color lime400 = Color(0xFF487237);
  static const Color lime500 = Color(0xFF284725);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORS — Coral scale
  // ---------------------------------------------------------------------------

  static const Color coral100 = Color(0xFFE2C0C0);
  static const Color coral200 = Color(0xFFDB9191);
  static const Color coral300 = Color(0xFFDA5959);
  static const Color coral400 = Color(0xFFA82A2A);
  static const Color coral500 = Color(0xFF721616);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORS — Amber scale
  // ---------------------------------------------------------------------------

  static const Color amber100 = Color(0xFFEFDCBF);
  static const Color amber200 = Color(0xFFF1C77C);
  static const Color amber300 = Color(0xFFE0A734);
  static const Color amber400 = Color(0xFFB07A26);
  static const Color amber500 = Color(0xFF79500B);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORS — Purple scale
  // ---------------------------------------------------------------------------

  /// Faint lavender card background — selected-client highlight card.
  static const Color purple50 = Color(0xFFF5F6FE);
  static const Color purple100 = Color(0xFFE7E5F2);
  static const Color purple200 = Color(0xFFB8B5C6);
  static const Color purple300 = Color(0xFF89849B);
  static const Color purple400 = Color(0xFF59546F);
  static const Color purple500 = Color(0xFF2A2343);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORS — Card grey scale
  //
  // A cooler grey ramp than the [neutral50]–[neutral800] scale, used by the
  // task and service-request card surfaces. Kept separate because the values
  // are close to but not interchangeable with the neutral scale — swapping
  // them shifts those cards visibly.
  // ---------------------------------------------------------------------------

  /// Card border on task and service-request cards.
  static const Color cardGrey100 = Color(0xFFE8EAED);

  /// Hairline divider between grouped card rows.
  static const Color cardGrey50 = Color(0xFFF1F3F4);

  /// Card heading text.
  static const Color cardGrey900 = Color(0xFF202124);

  /// Card subtitle text.
  static const Color cardGrey500 = Color(0xFF9AA0A6);

  /// Card metadata text, e.g. the task due-date row.
  static const Color cardGrey600 = Color(0xFF80868B);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORS — Static (never change between themes)
  // ---------------------------------------------------------------------------

  /// Pure white.
  static const Color staticWhite = Color(0xFFFFFFFF);

  /// Pure black.
  static const Color staticBlack = Color(0xFF000000);

  /// Fully transparent.
  static const Color staticTransparent = Color(0x00000000);

  /// Near-transparent white (alpha 1/255 ≈ 0.4 %) — used as a hairline white overlay.
  static const Color staticWhiteFaint = Color(0x01FFFFFF);

  // ---------------------------------------------------------------------------
  // LEGACY ALIASES
  // Kept for backward compatibility. New code should use AppColorTokens.
  // ---------------------------------------------------------------------------

  /// @deprecated Use [staticWhite].
  static const Color white = staticWhite;

  /// @deprecated Use [staticBlack].
  static const Color black = staticBlack;

  /// @deprecated Use AppColorTokens.bgPrimary via context.appColors.
  static const Color backgroundPage = neutral50;

  /// @deprecated Use AppColorTokens.surfaceDefault via context.appColors.
  static const Color cardBackground = staticWhite;

  /// @deprecated Use AppColorTokens.borderStrong via context.appColors.
  static const Color cardBorder = Color(0xFFE2E8F0);

  /// @deprecated Use [brandFinHubBlue].
  static const Color logoBlue = Color(0xFF1FB4E6);

  /// @deprecated Use [brandFinHubBlue].
  static const Color primaryAction = brandFinHubBlue;

  /// Decorative radial blur overlay on the login card.
  static const Color cardBlurOverlay = Color(0x0D00B3E6);

  /// @deprecated Use AppColorTokens.textPrimary via context.appColors.
  static const Color headingText = Color(0xFF142641);

  /// @deprecated Use AppColorTokens.textSecondary via context.appColors.
  static const Color subtitleText = neutral600;

  /// @deprecated Use [neutral600].
  static const Color secondaryColor = neutral600;

  /// @deprecated Use AppColorTokens.textSecondary via context.appColors.
  static const Color footerText = neutral600;

  /// @deprecated Use AppColorTokens.textDisabled via context.appColors.
  static const Color textHint = Color(0xFFA0AEC0);

  /// @deprecated Use AppColorTokens.textOnAccent via context.appColors.
  static const Color textOnPrimary = staticWhite;

  /// @deprecated Use AppColorTokens.borderDefault via context.appColors.
  static const Color inputBorder = neutral100;

  /// Search input border — slightly darker than [inputBorder].
  static const Color searchBorder = Color(0xFFD1D5DB);

  // Status / feedback — kept for chip and badge usage across existing widgets.
  // These now alias design-system primitives; use AppColorTokens.status* for
  // adaptive light/dark behaviour.

  static const Color defaultChipBg = neutral100;
  static const Color defaultChipColor = neutral400;

  /// Info / in-progress badge background — blue50.
  static const Color primaryBg = blue50;

  /// Info / in-progress badge foreground — blue400.
  static const Color primaryColor = blue400;

  /// Success background — lime100.
  static const Color successBg = lime100;

  /// Success foreground — lime300.
  static const Color successColor = lime300;

  /// Warning background — amber100.
  static const Color warningBg = amber100;

  /// Warning foreground — amber300.
  static const Color warningColor = amber300;

  /// Error background — coral100.
  static const Color errorBg = coral100;

  /// Error foreground — coral300.
  static const Color errorColor = coral300;

  /// @deprecated Use [errorColor].
  static const Color error = errorColor;

  // ---------------------------------------------------------------------------
  // Elevation / shadow
  // ---------------------------------------------------------------------------

  /// Card drop-shadow — 5 % black.
  static const Color cardShadow = Color.fromRGBO(0, 0, 0, 0.05);

  // Dashboard / financial colours.
  static const Color primaryText = Color(0xFF142641);
  static const Color mutedText = neutral600;
  static const Color returnPositive = lime300;
  static const Color slate100 = neutral50;
  static const Color assetEquity = Color(0xFF2D87C5);
  static const Color assetFixedIncome = gold300;
  static const Color assetAlts = Color(0xFF143968);
  static const Color assetCash = Color(0xFFCBD5E1);

  /// Muted label colour for compact metric labels (e.g. "MKT PRICE").
  static const Color metricLabelMuted = Color(0xFF4B5563);

  /// Dense numeric value colour for compact metric readouts.
  static const Color metricValueDense = Color(0xFF0F172A);

  // Account cards.
  static const Color allocationBarBg = Color.fromARGB(255, 226, 234, 243);
  static const Color avatarGradientStart = Color(0xFF475569);

  // ---------------------------------------------------------------------------
  // Risk-profile badge colours
  //
  // The backend returns one of two risk scales (see `RiskProfile`). Every one of
  // the nine profiles gets its own hue — no two badges are ever the same colour,
  // so a label is identifiable at a glance without reading it. Within a scale
  // the hues still walk a green → red severity arc.
  //
  //   Conservative scale:  green → olive → bronze → burnt orange → crimson
  //   Low/High scale:      teal → amber → red → magenta
  //
  // Each profile declares a foreground for the light theme and one for the dark
  // theme. `RiskBadge` derives the pill background by tinting the foreground, so
  // only these two values per profile need maintaining. Severity reads as
  // *darker* in the light theme and as *more saturated* in the dark theme, which
  // is why the two columns do not simply mirror each other.
  // ---------------------------------------------------------------------------

  // ── "Conservative" → "Significant Risk" scale ──────────────────────────────

  /// "Conservative" foreground, light theme — deep forest green.
  static const Color riskConservativeLight = lime500;

  /// "Conservative" foreground, dark theme — pale green.
  static const Color riskConservativeDark = lime200;

  /// "Moderately Conservative" foreground, light theme — olive.
  ///
  /// No olive exists in the primitive ramps; the shade is declared here so it
  /// stays clearly yellower than the forest green of "Conservative".
  static const Color riskModeratelyConservativeLight = Color(0xFF4D7C0F);

  /// "Moderately Conservative" foreground, dark theme — chartreuse.
  static const Color riskModeratelyConservativeDark = Color(0xFFBEF264);

  /// "Moderate" foreground, light theme — bronze.
  static const Color riskModerateLight = gold500;

  /// "Moderate" foreground, dark theme — tan.
  static const Color riskModerateDark = gold200;

  /// "Moderately Aggressive" foreground, light theme — burnt orange.
  ///
  /// There is no orange primitive ramp in the design system, so the shade is
  /// declared here. Sits between the bronze of "Moderate" and the crimson of
  /// "Significant Risk".
  static const Color riskModeratelyAggressiveLight = Color(0xFFC2410C);

  /// "Moderately Aggressive" foreground, dark theme — burnt orange.
  static const Color riskModeratelyAggressiveDark = Color(0xFFFB923C);

  /// "Significant Risk" foreground, light theme — deep crimson.
  static const Color riskSignificantLight = coral500;

  /// "Significant Risk" foreground, dark theme — bright salmon red.
  ///
  /// Deliberately brighter than [riskHighDark]: on a dark surface, saturation
  /// rather than darkness is what reads as severity.
  static const Color riskSignificantDark = Color(0xFFF87171);

  // ── "Low Risk" → "Speculative" scale ───────────────────────────────────────

  /// "Low Risk" foreground, light theme — teal.
  static const Color riskLowLight = teal400;

  /// "Low Risk" foreground, dark theme — bright teal.
  static const Color riskLowDark = teal200;

  /// "Moderate Risk" foreground, light theme — ochre.
  ///
  /// Darker and more saturated than [amber400], which does not clear 4.5:1
  /// against the pill fill at the badge's 10px size.
  static const Color riskModerateRiskLight = Color(0xFF8A6116);

  /// "Moderate Risk" foreground, dark theme — light amber.
  static const Color riskModerateRiskDark = amber200;

  /// "High Risk" foreground, light theme — red.
  static const Color riskHighLight = coral400;

  /// "High Risk" foreground, dark theme — muted rose.
  static const Color riskHighDark = coral200;

  /// "Speculative" foreground, light theme — magenta.
  ///
  /// Steps off the red ramp on purpose: "Speculative" is the most extreme
  /// profile, and a distinct hue keeps it from blurring into the two reds.
  static const Color riskSpeculativeLight = Color(0xFF86198F);

  /// "Speculative" foreground, dark theme — bright magenta.
  static const Color riskSpeculativeDark = Color(0xFFE879F9);

  // Dark palette — used by AppTheme.dark explicit overrides.
  static const Color backgroundPageDark = blue800;
  static const Color cardBackgroundDark = neutral800;
  static const Color inputBorderDark = neutral700;

  // Dark-mode status tint backgrounds (no primitive equivalent — composite tints).

  /// Dark success tinted background for banners and chips.
  static const Color darkStatusSuccessBg = Color(0xFF1A2D1A);

  /// Dark error tinted background for banners and chips.
  static const Color darkStatusErrorBg = Color(0xFF2D1A1A);

  /// Dark warning tinted background for banners and chips.
  static const Color darkStatusWarningBg = Color(0xFF2D2510);

  /// Dark info tinted background for banners and chips.
  static const Color darkStatusInfoBg = Color(0xFF0D1F2D);

  /// Dark primary tinted background for banners and chips.
  static const Color darkStatusPrimaryBg = Color(0xFF0D2A38);
}
