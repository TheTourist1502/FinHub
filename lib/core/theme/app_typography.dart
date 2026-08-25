import 'package:finhub/core/theme/app_colors.dart';
import 'package:flutter/painting.dart';

export 'package:finhub/core/theme/text_style_extensions.dart';

/// Text-style constants for the FinHub app.
///
/// All styles use the bundled Inter font family and are derived from the
/// Figma design spec (node 1:2114). Reference these constants in widgets
/// rather than constructing inline [TextStyle] objects.
class AppTypography {
  const AppTypography._();

  static const String _family = 'Inter';

  // ---------------------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------------------

  /// "finhub" wordmark — Inter Bold 24 px, cyan-blue.
  static const TextStyle logoStyle = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: AppColors.logoBlue,
    letterSpacing: 0,
    height: 1.2,
  );

  // ---------------------------------------------------------------------------
  // Page
  // ---------------------------------------------------------------------------

  /// Screen-level heading — Inter SemiBold 24 px (Figma h2).
  ///
  /// No hardcoded colour — inherits the theme's onSurface colour so it
  /// renders correctly in both light and dark modes.
  static const TextStyle pageTitle = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 24,
    letterSpacing: -0.24,
    height: 1.3,
  );

  /// Screen-level subheading — Inter Regular 14 px, grey.
  static const TextStyle pageSubtitle = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    color: AppColors.subtitleText,
  );

  // ---------------------------------------------------------------------------
  // Section
  // ---------------------------------------------------------------------------

  /// Section heading — Inter SemiBold 20 px (Figma h3).
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.3,
  );

  /// Section subheading — Inter Regular 14 px, grey.
  static const TextStyle sectionSubtitle = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    color: AppColors.subtitleText,
  );

  // ---------------------------------------------------------------------------
  // Card
  // ---------------------------------------------------------------------------

  /// Card heading — Inter Medium 18 px (Figma h4).
  static const TextStyle cardTitle = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 1.3,
  );

  /// Card subheading — Inter Regular 14 px, grey.
  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    color: AppColors.subtitleText,
  );

  /// Card meta / footer line — Inter Regular 12 px, slate grey.
  static const TextStyle cardMeta = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.4,
    color: AppColors.footerText,
  );

  // ---------------------------------------------------------------------------
  // Form
  // ---------------------------------------------------------------------------

  /// Form field label — Inter Medium 14 px.
  ///
  /// No hardcoded colour — inherits the theme's onSurface colour.
  static const TextStyle labelMedium = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.43,
  );

  /// Form field label — Inter Medium 14 px.
  static const TextStyle formLabel = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.4,
  );

  /// Input field text — Inter Regular 16 px.
  ///
  /// No hardcoded colour — inherits the theme's onSurface colour.
  static const TextStyle inputText = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  /// Form value / input field text — Inter Regular 16 px.
  static const TextStyle formValue = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
  );

  /// Input hint / placeholder style — Inter Regular 16 px.
  ///
  /// No hardcoded colour — hint colour is theme-driven and comes from
  /// `context.appColors.inputHintColor`. The global `inputDecorationTheme`
  /// already applies it, so only call sites that build their own `hintStyle`
  /// need to `copyWith` it.
  static const TextStyle inputHint = TextStyle(fontFamily: _family, fontWeight: FontWeight.w400, fontSize: 16);

  /// Search box text **and** placeholder — Inter Regular 14 px.
  ///
  /// One step down from [inputText] so a search box reads as a filter rather
  /// than a form field. Applied by [AppTheme.searchDecoration]; no call site
  /// should build its own search text style.
  static const TextStyle searchText = TextStyle(fontFamily: _family, fontWeight: FontWeight.w400, fontSize: 14);

  /// Compact input text **and** placeholder — Inter Regular 13 px.
  ///
  /// Used by the dense service-request forms, where the value and its hint
  /// deliberately share one style so a filled field reads at the same size
  /// as an empty one. No hardcoded colour — apply
  /// `context.appColors.textSecondary` at the call site.
  static const TextStyle inputTextCompact = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 13,
  );

  /// Form hint / placeholder — Inter Regular 14 px, grey.
  static const TextStyle formHint = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.subtitleText,
  );

  /// Form helper text — Inter Regular 12 px, grey.
  static const TextStyle formHelper = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.subtitleText,
    height: 1.4,
  );

  /// Form error text — Inter Medium 12 px, red.
  static const TextStyle formError = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: AppColors.error,
    height: 1.4,
  );

  // ---------------------------------------------------------------------------
  // Buttons
  // ---------------------------------------------------------------------------

  /// Primary button label — Inter Medium 14 px, white.
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.textOnPrimary,
    height: 1.43,
  );

  /// Large button label — Inter SemiBold 16 px, white.
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.textOnPrimary,
  );

  /// Medium button label — Inter SemiBold 14 px, white.
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: AppColors.textOnPrimary,
  );

  /// Small button label — Inter SemiBold 12 px, white.
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: AppColors.textOnPrimary,
  );

  /// Social / ghost button label — Inter Medium 14 px.
  ///
  /// No hardcoded colour — inherits the theme's onSurface colour.
  static const TextStyle socialButtonLabel = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.43,
  );

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Bottom-nav / tab label — Inter Medium 12 px.
  static const TextStyle navigationLabel = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.2,
  );

  // ---------------------------------------------------------------------------
  // Chip
  // ---------------------------------------------------------------------------

  /// Chip label — Inter SemiBold 11 px, tracked.
  static const TextStyle chipLabel = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 11,
    letterSpacing: 0.3,
    height: 1.2,
  );

  // ---------------------------------------------------------------------------
  // Dialog
  // ---------------------------------------------------------------------------

  /// Dialog heading — Inter SemiBold 20 px.
  static const TextStyle dialogTitle = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 20,
  );

  /// Dialog body — Inter Regular 14 px, grey.
  static const TextStyle dialogDescription = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.subtitleText,
    height: 1.5,
  );

  // ---------------------------------------------------------------------------
  // Table
  // ---------------------------------------------------------------------------

  /// Table column header — Inter SemiBold 12 px, grey.
  static const TextStyle tableHeader = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: AppColors.subtitleText,
  );

  /// Table cell body — Inter Regular 14 px.
  static const TextStyle tableCell = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  // ---------------------------------------------------------------------------
  // Empty State
  // ---------------------------------------------------------------------------

  /// Empty-state heading — Inter SemiBold 20 px.
  static const TextStyle emptyStateTitle = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.4,
  );

  /// Empty-state description — Inter Regular 14 px, grey.
  static const TextStyle emptyStateDescription = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.subtitleText,
    height: 1.5,
  );

  // ---------------------------------------------------------------------------
  // Metadata
  // ---------------------------------------------------------------------------

  /// Metadata / secondary info — Inter Regular 12 px, slate grey.
  static const TextStyle metadata = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.footerText,
  );

  /// Overline / eyebrow — Inter SemiBold 10 px, grey, tracked (Figma overline).
  static const TextStyle overline = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 10,
    letterSpacing: 0.8,
    height: 1.4,
    color: AppColors.subtitleText,
  );

  /// Notification badge — Inter Bold 10 px, tracked.
  static const TextStyle badge = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w700,
    fontSize: 10,
    letterSpacing: 0.4,
  );

  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------

  /// Status chip label — Inter SemiBold 12 px.
  static const TextStyle status = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 12,
  );

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------

  /// Large body copy — Inter Regular 16 px.
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
  );

  /// Regular body copy — Inter Regular 14 px, grey.
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.subtitleText,
    height: 1.43,
  );

  /// Small body copy — Inter Regular 12 px, grey.
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.5,
    color: AppColors.subtitleText,
  );

  // ---------------------------------------------------------------------------
  // Links
  // ---------------------------------------------------------------------------

  /// Inline hyperlink — Inter Medium 14 px, blue, underlined.
  static const TextStyle link = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.primaryColor,
    decoration: TextDecoration.underline,
  );

  // ---------------------------------------------------------------------------
  // Divider
  // ---------------------------------------------------------------------------

  /// "OR" divider label — Inter SemiBold 12 px, uppercase, tracked.
  static const TextStyle dividerLabel = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: AppColors.subtitleText,
    letterSpacing: 0.6,
    height: 1.33,
  );

  // ---------------------------------------------------------------------------
  // Footer
  // ---------------------------------------------------------------------------

  /// Footer body — Inter Regular 12 px, grey.
  static const TextStyle footerBody = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.subtitleText,
    height: 1.33,
  );

  /// Footer tappable link — Inter Medium 12 px, underlined.
  ///
  /// No hardcoded colour — inherits the theme's onSurface colour.
  static const TextStyle footerLink = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    decoration: TextDecoration.underline,
    height: 1.33,
  );

  /// Disclaimer text — Inter Regular 10 px, slate grey.
  static const TextStyle disclaimer = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: AppColors.footerText,
    height: 1.25,
  );

  /// Disclaimer underlined link — same size, underlined.
  static const TextStyle disclaimerLink = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: AppColors.footerText,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.footerText,
    height: 1.25,
  );

  // ---------------------------------------------------------------------------
  // Data / KPI display
  // ---------------------------------------------------------------------------

  /// Large numeric KPI — Inter Light 32 px (Figma "data" token).
  ///
  /// No hardcoded colour — inherits the theme's onSurface colour.
  static const TextStyle dataDisplay = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w300,
    fontSize: 32,
    letterSpacing: -0.64,
    height: 1.2,
  );

  // ---------------------------------------------------------------------------
  // Chart — donut centre label
  // ---------------------------------------------------------------------------

  /// Donut-chart centre label (asset class name) — Inter Medium 9 px.
  ///
  /// No hardcoded colour — apply via `.copyWith(color: ...)` at the call site.
  static const TextStyle donutCenterLabel = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 9,
    height: 1.25,
  );

  /// Donut-chart centre percentage — Inter Bold 16 px.
  ///
  /// No hardcoded colour — apply via `.copyWith(color: ...)` at the call site.
  static const TextStyle donutCenterPercentage = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 13,
    height: 1.375,
  );

  /// Donut-chart centre value (compact currency amount) — Inter Medium 10 px.
  ///
  /// No hardcoded colour — apply via `.copyWith(color: ...)` at the call site.
  static const TextStyle donutCenterValue = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 1.25,
  );

  // ---------------------------------------------------------------------------
  // Headings (legacy — prefer pageTitle)
  // ---------------------------------------------------------------------------

  /// @deprecated Use [pageTitle] instead.
  static const TextStyle headingLarge = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 24,
    letterSpacing: -0.24,
    height: 1.3,
  );

  // ---------------------------------------------------------------------------
  // Utilities — raw size tokens, no weight / colour.
  // ---------------------------------------------------------------------------

  static const text8 = TextStyle(fontSize: 8);
  static const text10 = TextStyle(fontSize: 10);
  static const text12 = TextStyle(fontSize: 12);
  static const text14 = TextStyle(fontSize: 14);
  static const text16 = TextStyle(fontSize: 16);
  static const text20 = TextStyle(fontSize: 20);
  static const text24 = TextStyle(fontSize: 24);
  static const text28 = TextStyle(fontSize: 28);
  static const text32 = TextStyle(fontSize: 32);
}
