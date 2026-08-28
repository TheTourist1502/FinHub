import 'package:finhub/core/motion/app_motion.dart';
import 'package:flutter/widgets.dart';

/// Master switch for every animation in `lib/shared/animations`.
///
/// `true` — `SettleIn`, `FigureReveal`, `SlideIn`, `Wipe` and `Pressable` play
/// as designed.
///
/// `false` — each renders its finished frame on the very first pump. The
/// content is still built, still laid out and still tappable; it simply arrives
/// without motion. Nothing anywhere depends on an animation completing in order
/// to become visible, so flipping this can never hide content — that invariant
/// is what makes a single switch safe.
///
/// Meant as a blunt instrument: shipping a build without motion, or ruling
/// motion in or out while chasing a jank report. It is deliberately **not** a
/// user-facing setting — the platform's own "reduce motion" already is one, and
/// is honoured independently of this flag. See [animationsEnabled].
///
/// Scope is this directory. Implicit animations owned by feature widgets — an
/// `AnimatedSwitcher` crossfading a skeleton into content, the history chart's
/// own tween — call [AppMotion.duration] directly and keep running. Route
/// transitions come from `pageTransitionsTheme` and are likewise unaffected.
bool isAnimationApplicable = true;

/// Whether the animations in this directory should play right now.
///
/// Two independent gates, both of which must be open: the app-level
/// [isAnimationApplicable], and the platform's "reduce motion" accessibility
/// setting via [AppMotion.enabled]. Widgets in this directory call this rather
/// than [AppMotion.enabled] directly, which is what puts all of them behind the
/// one switch.
bool animationsEnabled(BuildContext context) => isAnimationApplicable && AppMotion.enabled(context);

/// [value] when animations should play, otherwise [Duration.zero] so an
/// implicit animation widget jumps straight to its target.
///
/// The [AppMotion.duration] equivalent for this directory — same contract, but
/// gated by [isAnimationApplicable] as well.
Duration animationDuration(BuildContext context, Duration value) => animationsEnabled(context) ? value : Duration.zero;
