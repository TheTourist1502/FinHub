import 'package:flutter/material.dart';

/// Motion tokens for the app's animation language.
///
/// The metaphor is money coming to rest: everything arrives quickly and
/// decelerates into position, and nothing springs or overshoots. An advisor
/// reading a balance should never watch it bounce.
///
/// Widgets read durations through [duration] rather than using the constants
/// directly, so that a user who has switched on the platform's "reduce motion"
/// accessibility setting is shown the final frame immediately.
abstract final class AppMotion {
  /// State flips the reader should barely register — chip selection, icon
  /// swaps, press feedback.
  static const Duration quick = Duration(milliseconds: 150);

  /// The default for content changes: skeleton-to-data crossfades, expansion.
  static const Duration base = Duration(milliseconds: 280);

  /// Entrances — a section or list row settling into place.
  static const Duration settle = Duration(milliseconds: 520);

  /// fl_chart's implicit tween growing a line or bar in from the floor. Longer
  /// than [base] because the whole plot travels, shorter than [settle] so the
  /// chart is touchable before the reader reaches for it.
  static const Duration chart = Duration(milliseconds: 400);

  /// A hero number rolling to its resting value. Long on purpose: this is the
  /// one moment in the app allowed to hold the reader's attention.
  static const Duration hero = Duration(milliseconds: 900);

  /// Delay between consecutive staggered entrances.
  static const Duration stagger = Duration(milliseconds: 60);

  /// Entrance curve — fast start, gentle stop.
  static const Curve enter = Curves.easeOutCubic;

  /// The settle curve. Its long decelerating tail is what separates a value
  /// coming to rest from one merely appearing; reserved for hero numbers.
  static const Curve settleCurve = Curves.easeOutQuint;

  /// Easing applied within each segment of a ported CSS keyframe sequence,
  /// matching the source's `animation-timing-function: ease-in-out`. Only
  /// `lib/shared/animations` ports should need it.
  static const Curve keyframe = Curves.easeInOut;

  /// Exit curve for anything leaving the screen.
  static const Curve exit = Curves.easeInCubic;

  /// Symmetric curve for a region that opens and closes along the same path —
  /// an accordion, a collapse transition. [enter] and [exit] are one-directional
  /// by design, so neither reads correctly when the same motion has to run
  /// backwards.
  static const Curve expand = Curves.easeInOutCubic;

  /// Whether animations should play, honouring the platform's "reduce motion"
  /// accessibility setting.
  static bool enabled(BuildContext context) => !MediaQuery.disableAnimationsOf(context);

  /// [value] when motion is enabled, otherwise [Duration.zero] so implicit
  /// animation widgets jump straight to their target.
  static Duration duration(BuildContext context, Duration value) => enabled(context) ? value : Duration.zero;
}
