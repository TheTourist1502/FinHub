/// Spacing, sizing, and border-radius constants for the FinHub app.
///
/// Derived from the Figma design spec (node 1:2114). Using named constants
/// rather than magic numbers makes layout intent clear and changes trivial.
class AppDimensions {
  const AppDimensions._();

  // ---------------------------------------------------------------------------
  // Border radii
  // ---------------------------------------------------------------------------

  /// Login card border-radius (24 px).
  static const double cardBorderRadius = 24;

  /// Input fields and action buttons border-radius (12 px).
  static const double inputBorderRadius = 12;

  /// Reused for primary and social-login buttons.
  static const double buttonBorderRadius = 12;

  // ---------------------------------------------------------------------------
  // Card / page padding
  // ---------------------------------------------------------------------------

  /// Horizontal padding inside the login card.
  static const double cardHorizontalPadding = 24;

  /// Vertical padding inside the login card (top and bottom).
  static const double cardVerticalPadding = 32;

  /// Horizontal margin between the card edges and the screen edge.
  static const double cardHorizontalMargin = 16;

  // ---------------------------------------------------------------------------
  // Interactive elements
  // ---------------------------------------------------------------------------

  /// Standard height for primary and social-login buttons.
  static const double buttonHeight = 48;

  /// Standard icon size inside social-login buttons.
  static const double socialButtonIconSize = 20;

  /// Minimum touch target size per accessibility guidelines.
  static const double minTouchTarget = 48;

  // ---------------------------------------------------------------------------
  // Decorative
  // ---------------------------------------------------------------------------

  /// Diameter of the radial blur circle in the top-right of the login card.
  static const double cardBlurCircleSize = 160;

  /// Blur sigma for the decorative card overlay.
  static const double cardBlurSigma = 32;

  // ---------------------------------------------------------------------------
  // Spacing
  // ---------------------------------------------------------------------------

  /// Extra small spacing (4px).
  static const double spaceSx = 4;

  /// Small spacing (8px).
  static const double spaceSm = 8;

  /// Medium spacing (16px).
  static const double spaceMd = 16;

  /// Large spacing (24px).
  static const double spaceLg = 24;

  /// Extra large spacing (32px).
  static const double spaceXl = 32;

  // ---------------------------------------------------------------------------
  // Generic Border Radii
  // ---------------------------------------------------------------------------

  /// Extra small border radius (4px).
  static const double borderRadiousSx = 4;

  /// Small border radius (8px).
  static const double borderRadiousSm = 8;

  /// Medium border radius (16px).
  static const double borderRadiousMd = 16;

  /// Large border radius (24px).
  static const double borderRadiousLg = 24;

  /// Extra large border radius (32px).
  static const double borderRadiousXl = 32;

  // Border radius circle
  static const double borderRadiousCircle = 9999;

  // ---------------------------------------------------------------------------
  // Sort header row
  // ---------------------------------------------------------------------------

  /// Fixed height for a list section's label + sort-control header row.
  static const double sortHeaderRowHeight = 28;

  /// Default flex weight for the label side of a sort header row.
  static const int sortHeaderLabelFlex = 55;

  /// Default flex weight for the sort-control side of a sort header row.
  static const int sortHeaderSortFlex = 45;

  /// Gap between a sort header row's label and its sort control. Applies only
  /// when a sort control is present — a label-only row gets no trailing gap.
  static const double sortHeaderRowSpacing = 10;
}
