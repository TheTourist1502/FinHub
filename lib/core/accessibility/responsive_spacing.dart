import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:flutter/widgets.dart';

class ResponsiveSpacing {
  ResponsiveSpacing._();

  static const double _baseWidth = 390;

  static const List<double> _steps = [
    0.825,
    0.850,
    0.875,
    0.900,
    0.925,
    0.950,
    0.975,
    1.000,
    1.025,
    1.050,
    1.075,
    1.100,
    1.125,
    1.150,
    1.175,
    1.200,
    1.250,
  ];

  static double _snap(double raw) => _steps.reduce(
    (a, b) => (b - raw).abs() < (a - raw).abs() ? b : a,
  );

  static double _scale(BuildContext context) => _snap(MediaQuery.of(context).size.width / _baseWidth);

  // ─── raw scaled value ─────────────────────────────────────────────────────
  static double value(BuildContext context, double base) => base * _scale(context);

  // ══════════════════════════════════════════════════════════════════════════
  //  PADDING — all sides
  // ══════════════════════════════════════════════════════════════════════════

  static EdgeInsets paddingSx(BuildContext ctx) => EdgeInsets.all(AppDimensions.spaceSx * _scale(ctx)); // 4

  static EdgeInsets paddingSm(BuildContext ctx) => EdgeInsets.all(AppDimensions.spaceSm * _scale(ctx)); // 8

  static EdgeInsets paddingMd(BuildContext ctx) => EdgeInsets.all(AppDimensions.spaceMd * _scale(ctx)); // 16

  static EdgeInsets paddingLg(BuildContext ctx) => EdgeInsets.all(AppDimensions.spaceLg * _scale(ctx)); // 24

  static EdgeInsets paddingXl(BuildContext ctx) => EdgeInsets.all(AppDimensions.spaceXl * _scale(ctx)); // 32

  // ══════════════════════════════════════════════════════════════════════════
  //  PADDING — horizontal (X)
  // ══════════════════════════════════════════════════════════════════════════

  static EdgeInsets paddingXSx(BuildContext ctx) =>
      EdgeInsets.symmetric(horizontal: AppDimensions.spaceSx * _scale(ctx));

  static EdgeInsets paddingXSm(BuildContext ctx) =>
      EdgeInsets.symmetric(horizontal: AppDimensions.spaceSm * _scale(ctx));

  static EdgeInsets paddingXMd(BuildContext ctx) =>
      EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd * _scale(ctx));

  static EdgeInsets paddingXLg(BuildContext ctx) =>
      EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg * _scale(ctx));

  static EdgeInsets paddingXXl(BuildContext ctx) =>
      EdgeInsets.symmetric(horizontal: AppDimensions.spaceXl * _scale(ctx));

  // ══════════════════════════════════════════════════════════════════════════
  //  PADDING — vertical (Y)
  // ══════════════════════════════════════════════════════════════════════════

  static EdgeInsets paddingYSx(BuildContext ctx) => EdgeInsets.symmetric(vertical: AppDimensions.spaceSx * _scale(ctx));

  static EdgeInsets paddingYSm(BuildContext ctx) => EdgeInsets.symmetric(vertical: AppDimensions.spaceSm * _scale(ctx));

  static EdgeInsets paddingYMd(BuildContext ctx) => EdgeInsets.symmetric(vertical: AppDimensions.spaceMd * _scale(ctx));

  static EdgeInsets paddingYLg(BuildContext ctx) => EdgeInsets.symmetric(vertical: AppDimensions.spaceLg * _scale(ctx));

  static EdgeInsets paddingYXl(BuildContext ctx) => EdgeInsets.symmetric(vertical: AppDimensions.spaceXl * _scale(ctx));

  // ══════════════════════════════════════════════════════════════════════════
  //  CARD / PAGE — named semantic padding from AppDimensions
  // ══════════════════════════════════════════════════════════════════════════

  static EdgeInsets cardPadding(BuildContext ctx) => EdgeInsets.symmetric(
    horizontal: AppDimensions.cardHorizontalPadding * _scale(ctx), // 24
    vertical: AppDimensions.cardVerticalPadding * _scale(ctx), // 32
  );

  // ══════════════════════════════════════════════════════════════════════════
  //  MARGIN — all sides
  // ══════════════════════════════════════════════════════════════════════════

  static EdgeInsets marginSx(BuildContext ctx) => EdgeInsets.all(AppDimensions.spaceSx * _scale(ctx));

  static EdgeInsets marginSm(BuildContext ctx) => EdgeInsets.all(AppDimensions.spaceSm * _scale(ctx));

  static EdgeInsets marginMd(BuildContext ctx) => EdgeInsets.all(AppDimensions.spaceMd * _scale(ctx));

  static EdgeInsets marginLg(BuildContext ctx) => EdgeInsets.all(AppDimensions.spaceLg * _scale(ctx));

  static EdgeInsets marginXl(BuildContext ctx) => EdgeInsets.all(AppDimensions.spaceXl * _scale(ctx));

  // ══════════════════════════════════════════════════════════════════════════
  //  MARGIN — horizontal (X)
  // ══════════════════════════════════════════════════════════════════════════

  static EdgeInsets marginXSx(BuildContext ctx) =>
      EdgeInsets.symmetric(horizontal: AppDimensions.spaceSx * _scale(ctx));

  static EdgeInsets marginXSm(BuildContext ctx) =>
      EdgeInsets.symmetric(horizontal: AppDimensions.spaceSm * _scale(ctx));

  static EdgeInsets marginXMd(BuildContext ctx) =>
      EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd * _scale(ctx));

  static EdgeInsets marginXLg(BuildContext ctx) =>
      EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg * _scale(ctx));

  static EdgeInsets marginXXl(BuildContext ctx) =>
      EdgeInsets.symmetric(horizontal: AppDimensions.spaceXl * _scale(ctx));

  // card horizontal margin (screen edge gap)
  static EdgeInsets cardMarginX(BuildContext ctx) => EdgeInsets.symmetric(
    horizontal: AppDimensions.cardHorizontalMargin * _scale(ctx), // 16
  );

  // ══════════════════════════════════════════════════════════════════════════
  //  MARGIN — vertical (Y)
  // ══════════════════════════════════════════════════════════════════════════

  static EdgeInsets marginYSx(BuildContext ctx) => EdgeInsets.symmetric(vertical: AppDimensions.spaceSx * _scale(ctx));

  static EdgeInsets marginYSm(BuildContext ctx) => EdgeInsets.symmetric(vertical: AppDimensions.spaceSm * _scale(ctx));

  static EdgeInsets marginYMd(BuildContext ctx) => EdgeInsets.symmetric(vertical: AppDimensions.spaceMd * _scale(ctx));

  static EdgeInsets marginYLg(BuildContext ctx) => EdgeInsets.symmetric(vertical: AppDimensions.spaceLg * _scale(ctx));

  static EdgeInsets marginYXl(BuildContext ctx) => EdgeInsets.symmetric(vertical: AppDimensions.spaceXl * _scale(ctx));

  // ══════════════════════════════════════════════════════════════════════════
  //  BORDER RADIUS — scaled
  // ══════════════════════════════════════════════════════════════════════════

  static double borderRadiusSx(BuildContext ctx) => AppDimensions.borderRadiousSx * _scale(ctx); // 4

  static double borderRadiusSm(BuildContext ctx) => AppDimensions.borderRadiousSm * _scale(ctx); // 8

  static double borderRadiusMd(BuildContext ctx) => AppDimensions.borderRadiousMd * _scale(ctx); // 16

  static double borderRadiusLg(BuildContext ctx) => AppDimensions.borderRadiousLg * _scale(ctx); // 24

  static double borderRadiusXl(BuildContext ctx) => AppDimensions.borderRadiousXl * _scale(ctx); // 32

  // circle never scales — always 9999
  static double get borderRadiusCircle => AppDimensions.borderRadiousCircle;

  // semantic
  static double cardBorderRadius(BuildContext ctx) => AppDimensions.cardBorderRadius * _scale(ctx); // 24

  static double inputBorderRadius(BuildContext ctx) => AppDimensions.inputBorderRadius * _scale(ctx); // 12

  static double buttonBorderRadius(BuildContext ctx) => AppDimensions.buttonBorderRadius * _scale(ctx); // 12

  // ══════════════════════════════════════════════════════════════════════════
  //  SIZING — scaled interactive element sizes
  // ══════════════════════════════════════════════════════════════════════════

  static double buttonHeight(BuildContext ctx) => AppDimensions.buttonHeight * _scale(ctx); // 48

  static double socialIconSize(BuildContext ctx) => AppDimensions.socialButtonIconSize * _scale(ctx); // 20

  // minTouchTarget never scales down — accessibility floor
  static double minTouchTarget(BuildContext ctx) =>
      (AppDimensions.minTouchTarget * _scale(ctx)).clamp(AppDimensions.minTouchTarget, double.infinity);
}
