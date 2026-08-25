import 'package:finhub/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Semantic color tokens that automatically adapt between light and dark themes.
///
/// These map directly to the FinHub Design System semantic layer
/// (https://design-system.finhub.example/#semantic-colors).
///
/// Access in widgets via the [AppColorTokensExtension] on [BuildContext]:
/// ```dart
/// final colors = context.appColors;
/// Container(color: colors.bgPrimary)
/// Text('Hello', style: TextStyle(color: colors.textPrimary))
/// ```
///
/// Or via [Theme]:
/// ```dart
/// Theme.of(context).extension<AppColorTokens>()!
/// ```
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    // bg
    required this.bgPrimary,
    required this.bgBrandNavyBlue,
    required this.bgOverlay,
    // surface
    required this.surfaceDefault,
    required this.surfaceRaised,
    required this.surfaceSunken,
    required this.surfaceDisabled,
    required this.surfaceWhiteFaint,
    required this.surfaceFilled,
    // text
    required this.textBrandNavyBlue,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textInverse,
    required this.textAccent,
    required this.textDisabled,
    required this.textOnAccent,
    required this.inputHintColor,
    required this.inputDisabledBg,
    // icon
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconAccent,
    required this.iconInverse,
    required this.iconDisabled,
    // border
    required this.borderDefault,
    required this.borderStrong,
    required this.borderAccent,
    required this.borderInverse,
    required this.borderSubtle,
    required this.uploadBorder,
    // interactive
    required this.interactiveDefault,
    required this.interactiveHover,
    required this.interactiveActive,
    required this.interactiveDisabled,
    required this.interactiveFocusRing,
    // chart
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
    required this.chart6,
    required this.chart7,
    required this.chart8,
    required this.chart9,
    required this.chart10,
    required this.chartPositive,
    required this.chartNegative,
    required this.chartFillPositive,
    required this.chartFillNegative,
    // status — success
    required this.statusSuccessDefault,
    required this.statusSuccessBg,
    required this.statusSuccessText,
    required this.statusSuccess,
    // status — error
    required this.statusErrorDefault,
    required this.statusErrorBg,
    required this.statusErrorText,
    required this.statusError,
    // status — warning
    required this.statusWarningDefault,
    required this.statusWarningBg,
    required this.statusWarningText,
    required this.statusWarning,
    // status — info
    required this.statusInfoDefault,
    required this.statusInfoBg,
    required this.statusInfoText,
    required this.statusInfo,
    // status — primary
    required this.statusPrimaryDefault,
    required this.statusPrimaryBg,
    required this.statusPrimaryText,
    required this.statusPrimary,
    // card
    required this.bgCard,
    required this.cardShadow,
  });

  // ---------------------------------------------------------------------------
  // bg — page-level background layers
  // ---------------------------------------------------------------------------

  /// Main app/page background.
  final Color bgPrimary;

  /// Fixed brand-navy background surface.
  final Color bgBrandNavyBlue;

  /// Scrim / modal overlay with opacity.
  final Color bgOverlay;

  // ---------------------------------------------------------------------------
  // surface — card, panel, and sheet surfaces
  // ---------------------------------------------------------------------------

  /// Default card / panel surface.
  final Color surfaceDefault;

  /// Raised surface — modals, popovers, tooltips.
  final Color surfaceRaised;

  /// Sunken / inset surface — wells, code blocks, recessed inputs.
  final Color surfaceSunken;

  /// Disabled state surface.
  final Color surfaceDisabled;

  /// Near-transparent white overlay (alpha 1/255) — static across themes.
  final Color surfaceWhiteFaint;

  /// Filled surface — form/list backgrounds that sit a step above the base
  /// surface (e.g. filled inputs, subtle row highlights).
  final Color surfaceFilled;

  // ---------------------------------------------------------------------------
  // text — foreground text colours
  // ---------------------------------------------------------------------------

  /// Fixed brand-navy text — static across themes.
  final Color textBrandNavyBlue;

  /// High-emphasis body and heading text.
  final Color textPrimary;

  /// Medium-emphasis secondary/subtitle text.
  final Color textSecondary;

  /// Low-emphasis muted/helper text.
  final Color textTertiary;

  /// Text rendered on an inverse (dark) surface in light mode, or light in dark.
  final Color textInverse;

  /// Accent / link text — FinHub blue (lighter in dark mode).
  final Color textAccent;

  /// Disabled / placeholder text.
  final Color textDisabled;

  /// Text rendered directly on an accent-coloured surface.
  final Color textOnAccent;

  /// Placeholder / hint text inside every text field and select across the app.
  ///
  /// This is the single source of truth for hint colour — every `hintStyle`
  /// must resolve its colour from this token rather than picking a text token
  /// of its own, so all inputs stay visually consistent.
  final Color inputHintColor;

  /// Fill of a disabled text field, search box or select trigger.
  ///
  /// Deliberately its own token rather than [surfaceDisabled]: inputs need a
  /// heavier grey than a disabled surface so a dead field reads as dead against
  /// the card it sits on.
  final Color inputDisabledBg;

  // ---------------------------------------------------------------------------
  // icon — icon foreground colours
  // ---------------------------------------------------------------------------

  /// High-emphasis primary icon.
  final Color iconPrimary;

  /// Medium-emphasis secondary icon.
  final Color iconSecondary;

  /// Accent icon — matches brand blue.
  final Color iconAccent;

  /// Icon on an inverse surface.
  final Color iconInverse;

  /// Disabled icon.
  final Color iconDisabled;

  // ---------------------------------------------------------------------------
  // border — stroke / divider colours
  // ---------------------------------------------------------------------------

  /// Default border for inputs, cards, and dividers.
  final Color borderDefault;

  /// Strong / emphasis border for focused or selected states.
  final Color borderStrong;

  /// Accent / brand border — FinHub blue.
  final Color borderAccent;

  /// Inverse border — dark on light, light on dark.
  final Color borderInverse;

  /// Hairline divider border — lower contrast than [borderDefault].
  /// Used for e.g. `border-top: 1px solid #F3F4F6` row/section separators.
  final Color borderSubtle;

  /// Dashed border for document upload drop zones.
  final Color uploadBorder;

  // ---------------------------------------------------------------------------
  // interactive — button, link, and control states
  // ---------------------------------------------------------------------------

  /// Default interactive fill — primary brand blue.
  final Color interactiveDefault;

  /// Hover state — one step darker than default.
  final Color interactiveHover;

  /// Active / pressed state — darkest interactive.
  final Color interactiveActive;

  /// Disabled interactive element fill.
  final Color interactiveDisabled;

  /// Focus ring outline colour.
  final Color interactiveFocusRing;

  // ---------------------------------------------------------------------------
  // chart — data visualisation palette
  // ---------------------------------------------------------------------------

  /// Chart series colour 1 — equity (asset class).
  final Color chart1;

  /// Chart series colour 2 — fixed income (asset class).
  final Color chart2;

  /// Chart series colour 3 — alts (asset class).
  final Color chart3;

  /// Chart series colour 4 — cash (asset class).
  final Color chart4;

  /// Chart series colour 5 — blue.
  final Color chart5;

  /// Chart series colour 6 — teal.
  final Color chart6;

  /// Chart series colour 7 — purple.
  final Color chart7;

  /// Chart series colour 8 — coral.
  final Color chart8;

  /// Chart series colour 9 — lime.
  final Color chart9;

  /// Chart series colour 10 — amber.
  final Color chart10;

  /// Positive / gain indicator — lime.
  final Color chartPositive;

  /// Negative / loss indicator — coral.
  final Color chartNegative;

  /// Trend-chart positive-fill background — flat navy @ 10 % opacity.
  final Color chartFillPositive;

  /// Trend-chart negative-fill background.
  final Color chartFillNegative;

  // ---------------------------------------------------------------------------
  // status — success  (lime scale)
  // ---------------------------------------------------------------------------

  /// Success icon / badge fill — lime300.
  final Color statusSuccessDefault;

  /// Success tinted background for banners and chips — lime100 (light) / lime500 (dark).
  final Color statusSuccessBg;

  /// Success foreground text — lime400 (light) / lime200 (dark).
  final Color statusSuccessText;

  /// Success accent foreground — lime300 (light) / lime200 (dark).
  final Color statusSuccess;

  // ---------------------------------------------------------------------------
  // status — error  (coral scale)
  // ---------------------------------------------------------------------------

  /// Error icon / badge fill — coral300.
  final Color statusErrorDefault;

  /// Error tinted background for banners and chips — coral100 (light) / coral500 (dark).
  final Color statusErrorBg;

  /// Error foreground text — coral400 (light) / coral200 (dark).
  final Color statusErrorText;

  /// Error accent foreground — coral300 (light) / coral200 (dark).
  final Color statusError;

  // ---------------------------------------------------------------------------
  // status — warning  (amber scale)
  // ---------------------------------------------------------------------------

  /// Warning icon / badge fill — amber300.
  final Color statusWarningDefault;

  /// Warning tinted background for banners and chips — amber100 (light) / amber500 (dark).
  final Color statusWarningBg;

  /// Warning foreground text — amber400 (light) / amber200 (dark).
  final Color statusWarningText;

  /// Warning accent foreground — amber300 (light) / amber200 (dark).
  final Color statusWarning;

  // ---------------------------------------------------------------------------
  // status — info  (blue scale)
  // ---------------------------------------------------------------------------

  /// Info icon / badge fill — blue300.
  final Color statusInfoDefault;

  /// Info tinted background for banners and chips — blue50 (light) / blue700 (dark).
  final Color statusInfoBg;

  /// Info foreground text — blue500 (light) / blue200 (dark).
  final Color statusInfoText;

  /// Info accent foreground — brandFinHubBlue (light) / blue200 (dark).
  final Color statusInfo;

  // ---------------------------------------------------------------------------
  // status — primary  (brand blue scale)
  // ---------------------------------------------------------------------------

  /// Primary icon / badge fill — primary300.
  final Color statusPrimaryDefault;

  /// Primary tinted background for banners and chips — primary100 (light) / darkStatusPrimaryBg (dark).
  final Color statusPrimaryBg;

  /// Primary foreground text — primary500 (light) / primary200 (dark).
  final Color statusPrimaryText;

  /// Primary accent foreground — primary300 (light) / primary200 (dark).
  final Color statusPrimary;

  // ---------------------------------------------------------------------------
  // card — card surface and drop-shadow colours
  // ---------------------------------------------------------------------------

  /// Card background — fixed white.
  final Color bgCard;

  /// Card drop-shadow — adapts between light (5 % black) and dark (20 % black).
  final Color cardShadow;

  // ---------------------------------------------------------------------------
  // Factories
  // ---------------------------------------------------------------------------

  /// Light-mode semantic token set — maps primitives to their light values.
  static const AppColorTokens light = AppColorTokens(
    // bg
    bgPrimary: AppColors.neutral50,
    bgBrandNavyBlue: AppColors.brandNavyBlue,
    bgOverlay: Color(0x80000000),
    // surface
    surfaceDefault: AppColors.staticWhite,
    surfaceRaised: AppColors.staticWhite,
    surfaceSunken: AppColors.brandBoneBlue,
    surfaceDisabled: AppColors.neutral50,
    surfaceWhiteFaint: Color(0x01FFFFFF),
    surfaceFilled: AppColors.neutral25,
    // text
    textBrandNavyBlue: AppColors.brandNavyBlue,
    textPrimary: AppColors.primaryText,
    textSecondary: AppColors.neutral600,
    textTertiary: AppColors.neutral400,
    textInverse: AppColors.staticWhite,
    textAccent: AppColors.brandNavyBlue,
    textDisabled: AppColors.neutral300,
    textOnAccent: AppColors.staticWhite,
    inputHintColor: AppColors.neutral400,
    inputDisabledBg: AppColors.neutral100,
    // icon
    iconPrimary: AppColors.blue650,
    iconSecondary: AppColors.neutral500,
    iconAccent: AppColors.brandNavyBlue,
    iconInverse: AppColors.staticWhite,
    iconDisabled: AppColors.neutral300,
    // border
    borderDefault: Color(0xFFE6E6E8),
    borderStrong: AppColors.neutral200,

    borderAccent: AppColors.brandNavyBlue,
    borderInverse: AppColors.blue650,
    borderSubtle: Color(0xFFF3F4F6),
    uploadBorder: AppColors.searchBorder,
    // interactive
    interactiveDefault: AppColors.brandNavyBlue,
    interactiveHover: AppColors.blue700,
    interactiveActive: AppColors.blue800,
    interactiveDisabled: AppColors.neutral200,
    interactiveFocusRing: AppColors.brandNavyBlue,
    // chart — order matches semantic-light.figma chart.1–7
    chart1: AppColors.brandNavyBlue,
    chart2: AppColors.brandFinHubBlue,
    chart3: AppColors.purple400,
    chart4: AppColors.amber200,
    chart5: AppColors.gold200,
    chart6: AppColors.blue200,
    chart7: AppColors.neutral500,
    chart8: AppColors.coral300,
    chart9: AppColors.lime300,
    chart10: AppColors.amber300,

    chartPositive: AppColors.lime300,
    chartNegative: AppColors.coral300,

    chartFillPositive: Color.fromARGB(20, 13, 24, 70),
    chartFillNegative: Color.fromARGB(35, 218, 89, 89),
    // status — success
    statusSuccessDefault: AppColors.lime300,
    statusSuccessBg: AppColors.lime50,
    statusSuccess: AppColors.lime300,
    statusSuccessText: AppColors.lime500,
    // status — error
    statusErrorDefault: AppColors.coral300,
    statusErrorBg: AppColors.coral100,
    statusErrorText: AppColors.coral500,
    statusError: AppColors.coral300,
    // status — warning
    statusWarningDefault: AppColors.amber300,
    statusWarningBg: AppColors.amber100,
    statusWarningText: AppColors.amber500,
    statusWarning: AppColors.amber300,
    // status — info
    statusInfoDefault: AppColors.brandNavyBlue,
    statusInfoBg: AppColors.blue50,
    statusInfoText: AppColors.blue600,
    statusInfo: AppColors.brandFinHubBlue,
    // status — primary
    statusPrimaryDefault: AppColors.primary300,
    statusPrimaryBg: AppColors.primary100,
    statusPrimaryText: AppColors.primary500,
    statusPrimary: AppColors.primary300,
    // card
    bgCard: AppColors.staticWhite,
    cardShadow: AppColors.cardShadow,
  );

  /// Dark-mode semantic token set — maps primitives to their dark values.
  static const AppColorTokens dark = AppColorTokens(
    // bg
    bgPrimary: AppColors.neutral800,
    bgBrandNavyBlue: AppColors.brandNavyBlue,
    bgOverlay: Color(0x80000000),
    // surface
    surfaceDefault: AppColors.neutral700,
    surfaceRaised: AppColors.neutral600,
    surfaceSunken: AppColors.blue800,
    surfaceDisabled: AppColors.neutral600,
    surfaceWhiteFaint: AppColors.staticWhiteFaint,
    surfaceFilled: AppColors.neutral600,
    // text
    textBrandNavyBlue: AppColors.brandNavyBlue,
    textPrimary: AppColors.neutral50,
    textSecondary: AppColors.neutral300,
    textTertiary: AppColors.neutral500,
    textInverse: AppColors.blue650,
    textAccent: AppColors.blue200,
    textDisabled: AppColors.neutral600,
    textOnAccent: AppColors.blue800,
    inputHintColor: AppColors.neutral500,
    inputDisabledBg: AppColors.neutral600,
    // icon
    iconPrimary: AppColors.neutral100,
    iconSecondary: AppColors.neutral400,
    iconAccent: AppColors.blue200,
    iconInverse: AppColors.blue650,
    iconDisabled: AppColors.neutral600,
    // border
    borderDefault: AppColors.neutral700,
    borderStrong: AppColors.neutral100,
    borderAccent: AppColors.blue200,
    borderInverse: AppColors.staticWhite,
    borderSubtle: Color(0xFF242B35),
    uploadBorder: AppColors.neutral600,
    // interactive
    interactiveDefault: AppColors.blue200,
    interactiveHover: AppColors.blue200,
    interactiveActive: AppColors.blue100,
    interactiveDisabled: AppColors.neutral700,
    interactiveFocusRing: AppColors.blue200,
    // chart — order matches semantic-dark.figma chart.1–7
    chart1: AppColors.blue200,
    chart2: AppColors.teal200,
    chart3: AppColors.purple200,
    chart4: AppColors.amber200,
    chart5: AppColors.gold200,
    chart6: AppColors.blue200,
    chart7: AppColors.neutral300,
    chart8: AppColors.coral200,
    chart9: AppColors.lime200,
    chart10: AppColors.amber200,
    chartPositive: AppColors.lime200,
    chartNegative: AppColors.coral200,
    chartFillPositive: Color.fromRGBO(13, 24, 70, 0.10),
    chartFillNegative: AppColors.coral200,
    // status — success
    statusSuccessDefault: AppColors.lime200,
    statusSuccessBg: AppColors.darkStatusSuccessBg,
    statusSuccessText: AppColors.lime200,
    statusSuccess: AppColors.lime200,
    // status — error
    statusErrorDefault: AppColors.coral200,
    statusErrorBg: AppColors.darkStatusErrorBg,
    statusErrorText: AppColors.coral200,
    statusError: AppColors.coral200,
    // status — warning
    statusWarningDefault: AppColors.amber200,
    statusWarningBg: AppColors.darkStatusWarningBg,
    statusWarningText: AppColors.amber200,
    statusWarning: AppColors.amber200,
    // status — info
    statusInfoDefault: AppColors.blue200,
    statusInfoBg: AppColors.darkStatusInfoBg,
    statusInfoText: AppColors.blue200,
    statusInfo: AppColors.blue200,
    // status — primary
    statusPrimaryDefault: AppColors.primary200,
    statusPrimaryBg: AppColors.darkStatusPrimaryBg,
    statusPrimaryText: AppColors.primary200,
    statusPrimary: AppColors.primary200,
    // card
    bgCard: AppColors.staticWhite,
    cardShadow: Color.fromRGBO(0, 0, 0, 0.2),
  );

  // ---------------------------------------------------------------------------
  // ThemeExtension overrides
  // ---------------------------------------------------------------------------

  @override
  AppColorTokens copyWith({
    Color? bgPrimary,
    Color? bgBrandNavyBlue,
    Color? bgOverlay,
    Color? surfaceDefault,
    Color? surfaceRaised,
    Color? surfaceSunken,
    Color? surfaceDisabled,
    Color? surfaceWhiteFaint,
    Color? surfaceFilled,
    Color? textBrandNavyBlue,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textInverse,
    Color? textAccent,
    Color? textDisabled,
    Color? textOnAccent,
    Color? inputHintColor,
    Color? inputDisabledBg,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? iconAccent,
    Color? iconInverse,
    Color? iconDisabled,
    Color? borderDefault,
    Color? borderStrong,
    Color? borderAccent,
    Color? borderInverse,
    Color? borderSubtle,
    Color? uploadBorder,
    Color? interactiveDefault,
    Color? interactiveHover,
    Color? interactiveActive,
    Color? interactiveDisabled,
    Color? interactiveFocusRing,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
    Color? chart6,
    Color? chart7,
    Color? chart8,
    Color? chart9,
    Color? chart10,
    Color? chartPositive,
    Color? chartNegative,
    Color? chartFillPositive,
    Color? chartFillNegative,
    Color? statusSuccessDefault,
    Color? statusSuccessBg,
    Color? statusSuccessText,
    Color? statusSuccess,
    Color? statusErrorDefault,
    Color? statusErrorBg,
    Color? statusErrorText,
    Color? statusError,
    Color? statusWarningDefault,
    Color? statusWarningBg,
    Color? statusWarningText,
    Color? statusWarning,
    Color? statusInfoDefault,
    Color? statusInfoBg,
    Color? statusInfoText,
    Color? statusInfo,
    Color? statusPrimaryDefault,
    Color? statusPrimaryBg,
    Color? statusPrimaryText,
    Color? statusPrimary,
    Color? bgCard,
    Color? cardShadow,
  }) {
    return AppColorTokens(
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgBrandNavyBlue: bgBrandNavyBlue ?? this.bgBrandNavyBlue,
      bgOverlay: bgOverlay ?? this.bgOverlay,
      surfaceDefault: surfaceDefault ?? this.surfaceDefault,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      surfaceDisabled: surfaceDisabled ?? this.surfaceDisabled,
      surfaceWhiteFaint: surfaceWhiteFaint ?? this.surfaceWhiteFaint,
      surfaceFilled: surfaceFilled ?? this.surfaceFilled,
      textBrandNavyBlue: textBrandNavyBlue ?? this.textBrandNavyBlue,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textInverse: textInverse ?? this.textInverse,
      textAccent: textAccent ?? this.textAccent,
      textDisabled: textDisabled ?? this.textDisabled,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      inputHintColor: inputHintColor ?? this.inputHintColor,
      inputDisabledBg: inputDisabledBg ?? this.inputDisabledBg,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      iconAccent: iconAccent ?? this.iconAccent,
      iconInverse: iconInverse ?? this.iconInverse,
      iconDisabled: iconDisabled ?? this.iconDisabled,
      borderDefault: borderDefault ?? this.borderDefault,
      borderStrong: borderStrong ?? this.borderStrong,
      borderAccent: borderAccent ?? this.borderAccent,
      borderInverse: borderInverse ?? this.borderInverse,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      uploadBorder: uploadBorder ?? this.uploadBorder,
      interactiveDefault: interactiveDefault ?? this.interactiveDefault,
      interactiveHover: interactiveHover ?? this.interactiveHover,
      interactiveActive: interactiveActive ?? this.interactiveActive,
      interactiveDisabled: interactiveDisabled ?? this.interactiveDisabled,
      interactiveFocusRing: interactiveFocusRing ?? this.interactiveFocusRing,
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
      chart6: chart6 ?? this.chart6,
      chart7: chart7 ?? this.chart7,
      chart8: chart8 ?? this.chart8,
      chart9: chart9 ?? this.chart9,
      chart10: chart10 ?? this.chart10,
      chartPositive: chartPositive ?? this.chartPositive,
      chartNegative: chartNegative ?? this.chartNegative,
      chartFillPositive: chartFillPositive ?? this.chartFillPositive,
      chartFillNegative: chartFillNegative ?? this.chartFillNegative,
      statusSuccessDefault: statusSuccessDefault ?? this.statusSuccessDefault,
      statusSuccessBg: statusSuccessBg ?? this.statusSuccessBg,
      statusSuccessText: statusSuccessText ?? this.statusSuccessText,
      statusSuccess: statusSuccess ?? this.statusSuccess,
      statusErrorDefault: statusErrorDefault ?? this.statusErrorDefault,
      statusErrorBg: statusErrorBg ?? this.statusErrorBg,
      statusErrorText: statusErrorText ?? this.statusErrorText,
      statusError: statusError ?? this.statusError,
      statusWarningDefault: statusWarningDefault ?? this.statusWarningDefault,
      statusWarningBg: statusWarningBg ?? this.statusWarningBg,
      statusWarningText: statusWarningText ?? this.statusWarningText,
      statusWarning: statusWarning ?? this.statusWarning,
      statusInfoDefault: statusInfoDefault ?? this.statusInfoDefault,
      statusInfoBg: statusInfoBg ?? this.statusInfoBg,
      statusInfoText: statusInfoText ?? this.statusInfoText,
      statusInfo: statusInfo ?? this.statusInfo,
      statusPrimaryDefault: statusPrimaryDefault ?? this.statusPrimaryDefault,
      statusPrimaryBg: statusPrimaryBg ?? this.statusPrimaryBg,
      statusPrimaryText: statusPrimaryText ?? this.statusPrimaryText,
      statusPrimary: statusPrimary ?? this.statusPrimary,
      bgCard: bgCard ?? this.bgCard,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  AppColorTokens lerp(AppColorTokens? other, double t) {
    if (other == null) return this;
    return AppColorTokens(
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgBrandNavyBlue: Color.lerp(bgBrandNavyBlue, other.bgBrandNavyBlue, t)!,
      bgOverlay: Color.lerp(bgOverlay, other.bgOverlay, t)!,
      surfaceDefault: Color.lerp(surfaceDefault, other.surfaceDefault, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceSunken: Color.lerp(surfaceSunken, other.surfaceSunken, t)!,
      surfaceDisabled: Color.lerp(surfaceDisabled, other.surfaceDisabled, t)!,
      surfaceWhiteFaint: Color.lerp(surfaceWhiteFaint, other.surfaceWhiteFaint, t)!,
      surfaceFilled: Color.lerp(surfaceFilled, other.surfaceFilled, t)!,
      textBrandNavyBlue: Color.lerp(textBrandNavyBlue, other.textBrandNavyBlue, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      textAccent: Color.lerp(textAccent, other.textAccent, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textOnAccent: Color.lerp(textOnAccent, other.textOnAccent, t)!,
      inputHintColor: Color.lerp(inputHintColor, other.inputHintColor, t)!,
      inputDisabledBg: Color.lerp(inputDisabledBg, other.inputDisabledBg, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      iconAccent: Color.lerp(iconAccent, other.iconAccent, t)!,
      iconInverse: Color.lerp(iconInverse, other.iconInverse, t)!,
      iconDisabled: Color.lerp(iconDisabled, other.iconDisabled, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderAccent: Color.lerp(borderAccent, other.borderAccent, t)!,
      borderInverse: Color.lerp(borderInverse, other.borderInverse, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      uploadBorder: Color.lerp(uploadBorder, other.uploadBorder, t)!,
      interactiveDefault: Color.lerp(interactiveDefault, other.interactiveDefault, t)!,
      interactiveHover: Color.lerp(interactiveHover, other.interactiveHover, t)!,
      interactiveActive: Color.lerp(interactiveActive, other.interactiveActive, t)!,
      interactiveDisabled: Color.lerp(interactiveDisabled, other.interactiveDisabled, t)!,
      interactiveFocusRing: Color.lerp(interactiveFocusRing, other.interactiveFocusRing, t)!,
      chart1: Color.lerp(chart1, other.chart1, t)!,
      chart2: Color.lerp(chart2, other.chart2, t)!,
      chart3: Color.lerp(chart3, other.chart3, t)!,
      chart4: Color.lerp(chart4, other.chart4, t)!,
      chart5: Color.lerp(chart5, other.chart5, t)!,
      chart6: Color.lerp(chart6, other.chart6, t)!,
      chart7: Color.lerp(chart7, other.chart7, t)!,
      chart8: Color.lerp(chart8, other.chart8, t)!,
      chart9: Color.lerp(chart9, other.chart9, t)!,
      chart10: Color.lerp(chart10, other.chart10, t)!,
      chartPositive: Color.lerp(chartPositive, other.chartPositive, t)!,
      chartNegative: Color.lerp(chartNegative, other.chartNegative, t)!,
      chartFillPositive: Color.lerp(chartFillPositive, other.chartFillPositive, t)!,
      chartFillNegative: Color.lerp(chartFillNegative, other.chartFillNegative, t)!,
      statusSuccessDefault: Color.lerp(statusSuccessDefault, other.statusSuccessDefault, t)!,
      statusSuccessBg: Color.lerp(statusSuccessBg, other.statusSuccessBg, t)!,
      statusSuccessText: Color.lerp(statusSuccessText, other.statusSuccessText, t)!,
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      statusErrorDefault: Color.lerp(statusErrorDefault, other.statusErrorDefault, t)!,
      statusErrorBg: Color.lerp(statusErrorBg, other.statusErrorBg, t)!,
      statusErrorText: Color.lerp(statusErrorText, other.statusErrorText, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      statusWarningDefault: Color.lerp(statusWarningDefault, other.statusWarningDefault, t)!,
      statusWarningBg: Color.lerp(statusWarningBg, other.statusWarningBg, t)!,
      statusWarningText: Color.lerp(statusWarningText, other.statusWarningText, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      statusInfoDefault: Color.lerp(statusInfoDefault, other.statusInfoDefault, t)!,
      statusInfoBg: Color.lerp(statusInfoBg, other.statusInfoBg, t)!,
      statusInfoText: Color.lerp(statusInfoText, other.statusInfoText, t)!,
      statusInfo: Color.lerp(statusInfo, other.statusInfo, t)!,
      statusPrimaryDefault: Color.lerp(statusPrimaryDefault, other.statusPrimaryDefault, t)!,
      statusPrimaryBg: Color.lerp(statusPrimaryBg, other.statusPrimaryBg, t)!,
      statusPrimaryText: Color.lerp(statusPrimaryText, other.statusPrimaryText, t)!,
      statusPrimary: Color.lerp(statusPrimary, other.statusPrimary, t)!,
      bgCard: Color.lerp(bgCard, other.bgCard, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
    );
  }
}

/// Convenience extension so widgets can write `context.appColors.textPrimary`
/// instead of `Theme.of(context).extension<AppColorTokens>()!`.
extension AppColorTokensExtension on BuildContext {
  /// The adaptive semantic color tokens for the current theme.
  AppColorTokens get appColors => Theme.of(this).extension<AppColorTokens>()!;
}
